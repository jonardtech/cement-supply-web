-- ============================================================
-- JCIL / YAOBAI CEMENT DISTRIBUTION SYSTEM
-- Complete MySQL 8.0+ Schema (Final Version)
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1. USERS — All system users (JCIL staff + client portal users)
-- ============================================================
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM(
        'super_admin',
        'finance',
        'sales',
        'dispatch',
        'client_admin',
        'client_user'
    ) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    client_id BIGINT UNSIGNED NULL UNIQUE,       -- 1:1 link for client portal users (NULL for staff)
    mfa_secret VARCHAR(255) NULL,
    tos_accepted_at DATETIME NULL,
    tos_accepted_ip VARCHAR(45) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    login_attempts INT NOT NULL DEFAULT 0,
    locked_until DATETIME NULL,
    last_login_at DATETIME NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_role (role),
    INDEX idx_users_active (is_active),
    INDEX idx_users_client (client_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 2. CLIENTS — Business entities (construction companies, wholesalers)
-- ============================================================
CREATE TABLE clients (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    tin VARCHAR(20) NOT NULL UNIQUE,
    client_type ENUM(
        'construction_project',
        'wholesaler',
        'retailer'
    ) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NULL,
    physical_address TEXT NOT NULL,
    district VARCHAR(100) NOT NULL,
    acquisition_source ENUM(
        'sales_agent',
        'direct_admin',
        'referral',
        'walk_in',
        'marketing_campaign'
    ) NOT NULL DEFAULT 'direct_admin',
    default_payment_terms ENUM(
        'prepay',
        'net_7',
        'net_14',
        'net_30'
    ) NOT NULL DEFAULT 'prepay',
    credit_limit DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    current_credit_balance DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_clients_tin (tin),
    INDEX idx_clients_district (district),
    INDEX idx_clients_type (client_type),
    INDEX idx_clients_acquisition (acquisition_source)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Add FK from users to clients
ALTER TABLE users ADD CONSTRAINT fk_users_client 
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL;

-- ============================================================
-- 3. SALES_ASSIGNMENTS — OPTIONAL: Sales agent ↔ client relationship
-- A client may have ZERO or ONE active sales agent.
-- Historical assignments are kept (ended_at IS NOT NULL).
-- ============================================================
CREATE TABLE sales_assignments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    client_id BIGINT UNSIGNED NOT NULL,
    sales_agent_id BIGINT UNSIGNED NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT TRUE,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by BIGINT UNSIGNED NULL,
    ended_at DATETIME NULL,
    notes TEXT NULL,
    CONSTRAINT fk_sales_assignment_client FOREIGN KEY (client_id)
        REFERENCES clients(id) ON DELETE CASCADE,
    CONSTRAINT fk_sales_assignment_agent FOREIGN KEY (sales_agent_id)
        REFERENCES users(id),
    CONSTRAINT fk_sales_assignment_assigned_by FOREIGN KEY (assigned_by)
        REFERENCES users(id),
    INDEX idx_sales_client (client_id),
    INDEX idx_sales_agent (sales_agent_id),
    INDEX idx_sales_active (client_id, ended_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 4. CEMENT_CATEGORIES — Products (Yaobai cement variants)
-- ============================================================
CREATE TABLE cement_categories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    default_unit VARCHAR(20) NOT NULL DEFAULT 'bags',
    base_price DECIMAL(18,2) NOT NULL,
    ura_tax_code VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_cement_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 5. PRICING_ADJUSTMENTS — Volume discounts & region surcharges
-- ============================================================
CREATE TABLE pricing_adjustments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cement_category_id BIGINT UNSIGNED NOT NULL,
    adjustment_type ENUM(
        'volume_discount',
        'region_surcharge'
    ) NOT NULL,
    min_quantity DECIMAL(10,2) NULL,
    max_quantity DECIMAL(10,2) NULL,
    region VARCHAR(100) NULL,
    adjustment_value DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pricing_category FOREIGN KEY (cement_category_id)
        REFERENCES cement_categories(id) ON DELETE CASCADE,
    INDEX idx_pricing_category_type (cement_category_id, adjustment_type),
    INDEX idx_pricing_region (region),
    INDEX idx_pricing_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 6. ORDERS — References CLIENT (company), tracks who created/dispatched
-- ============================================================
CREATE TABLE orders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    client_id BIGINT UNSIGNED NOT NULL,
    created_by BIGINT UNSIGNED NOT NULL,
    status ENUM(
        'draft',
        'pending_payment',
        'confirmed',
        'scheduled',
        'in_transit',
        'delivered',
        'cancelled',
        'rejected'
    ) NOT NULL DEFAULT 'draft',
    delivery_date DATE NOT NULL,
    transport_mode ENUM(
        'yaobai_plant',
        'client_managed'
    ) NOT NULL,
    vehicle_reg VARCHAR(20) NULL,
    subtotal DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    vat_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    rejected_reason TEXT NULL,
    dispatched_at DATETIME NULL,
    dispatched_by BIGINT UNSIGNED NULL,
    notes TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_client FOREIGN KEY (client_id)
        REFERENCES clients(id),
    CONSTRAINT fk_orders_created_by FOREIGN KEY (created_by)
        REFERENCES users(id),
    CONSTRAINT fk_orders_dispatched_by FOREIGN KEY (dispatched_by)
        REFERENCES users(id),
    INDEX idx_orders_client_status (client_id, status),
    INDEX idx_orders_delivery_date (delivery_date),
    INDEX idx_orders_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 7. ORDER_ITEMS — Line items per order
-- ============================================================
CREATE TABLE order_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    cement_category_id BIGINT UNSIGNED NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL,
    volume_adj DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    region_adj DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    subtotal DECIMAL(18,2) NOT NULL,
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id)
        REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product FOREIGN KEY (cement_category_id)
        REFERENCES cement_categories(id),
    INDEX idx_order_items_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 8. INVOICES — Separate from orders (URA EFRIS lifecycle)
-- ============================================================
CREATE TABLE invoices (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    order_id BIGINT UNSIGNED NOT NULL,
    client_id BIGINT UNSIGNED NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    subtotal DECIMAL(18,2) NOT NULL,
    vat_amount DECIMAL(18,2) NOT NULL,
    total_amount DECIMAL(18,2) NOT NULL,
    efris_status ENUM(
        'pending',
        'submitted',
        'approved',
        'rejected',
        'voided'
    ) NOT NULL DEFAULT 'pending',
    ura_invoice_num VARCHAR(100) NULL,
    ura_invoice_url VARCHAR(500) NULL,
    efris_payload JSON NULL,
    pdf_url VARCHAR(500) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_invoices_order FOREIGN KEY (order_id)
        REFERENCES orders(id),
    CONSTRAINT fk_invoices_client FOREIGN KEY (client_id)
        REFERENCES clients(id),
    INDEX idx_invoices_efris_status (efris_status),
    INDEX idx_invoices_client (client_id),
    INDEX idx_invoices_issue_date (issue_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 9. PAYMENT_PROOFS — Manual reconciliation (Phase 1)
-- ============================================================
CREATE TABLE payment_proofs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    invoice_id BIGINT UNSIGNED NOT NULL,
    uploaded_by BIGINT UNSIGNED NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    file_size_bytes INT UNSIGNED NOT NULL,
    amount_ugx DECIMAL(18,2) NOT NULL,
    payment_method ENUM(
        'bank_transfer',
        'cheque'
    ) NOT NULL,
    bank_name VARCHAR(100) NULL,
    cheque_number VARCHAR(50) NULL,
    cheque_clearing_date DATE NULL,
    status ENUM(
        'pending_review',
        'verified',
        'rejected'
    ) NOT NULL DEFAULT 'pending_review',
    reconciled_by BIGINT UNSIGNED NULL,
    reconciled_at DATETIME NULL,
    rejection_reason TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id)
        REFERENCES invoices(id),
    CONSTRAINT fk_payment_uploaded_by FOREIGN KEY (uploaded_by)
        REFERENCES users(id),
    CONSTRAINT fk_payment_reconciled_by FOREIGN KEY (reconciled_by)
        REFERENCES users(id),
    INDEX idx_payment_status (status),
    INDEX idx_payment_invoice (invoice_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 10. MOBILE_DEVICES — Push notification tokens
-- ============================================================
CREATE TABLE mobile_devices (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    device_token VARCHAR(255) NOT NULL UNIQUE,
    device_os ENUM('ios', 'android') NOT NULL,
    app_version VARCHAR(20) NOT NULL,
    last_active_at DATETIME NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_devices_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_devices_user_active (user_id, is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 11. OFFLINE_SYNC_LOGS — Offline-first mobile conflict tracking
-- ============================================================
CREATE TABLE offline_sync_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    client_action_id VARCHAR(100) NOT NULL UNIQUE,
    action_type ENUM('create', 'update', 'delete') NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id BIGINT UNSIGNED NULL,
    local_timestamp DATETIME NOT NULL,
    payload_hash VARCHAR(64) NOT NULL,
    synced_at DATETIME NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sync_user FOREIGN KEY (user_id)
        REFERENCES users(id),
    INDEX idx_sync_user_synced (user_id, synced_at),
    INDEX idx_sync_entity (entity_type, entity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 12. AUDIT_LOGS — Full audit trail (ISO 27001 / Data Protection Act)
-- ============================================================
CREATE TABLE audit_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id BIGINT UNSIGNED NOT NULL,
    old_values JSON NULL,
    new_values JSON NULL,
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_audit_entity (entity_type, entity_id),
    INDEX idx_audit_created_at (created_at),
    INDEX idx_audit_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ============================================================
-- 13. SUPPORT_TICKETS — Client & staff support
-- ============================================================
CREATE TABLE support_tickets (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('low', 'medium', 'high', 'urgent') NOT NULL DEFAULT 'medium',
    status ENUM(
        'open',
        'in_progress',
        'resolved',
        'closed'
    ) NOT NULL DEFAULT 'open',
    assigned_to BIGINT UNSIGNED NULL,
    resolved_at DATETIME NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_tickets_user FOREIGN KEY (user_id)
        REFERENCES users(id),
    CONSTRAINT fk_tickets_assigned FOREIGN KEY (assigned_to)
        REFERENCES users(id),
    INDEX idx_tickets_user_status (user_id, status),
    INDEX idx_tickets_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET FOREIGN_KEY_CHECKS = 1;