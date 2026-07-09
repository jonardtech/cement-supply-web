# Architecture & Technology Stack

## Platform Strategy
The system is multi-platform, but the **Web Application is the single source of truth** containing all features.
- **Web Application (Next.js):** The complete system. Serves the JCIL Admin/Finance dashboards (optimized for Desktop monitors) and the Client Portal (optimized for Mobile/Desktop). 
- **Android App:** A companion app specifically for Clients and Sales Agents. Focuses on field workflows, offline capabilities, and mobile-first UX. (Parallel development).
- **Desktop App:** Native desktop application for JCIL Staff. (Parallel development, likely for specific hardware integrations or offline warehouse use).
- **The Golden Rule:** The Backend API is the master. All platforms (Web, Android, Desktop) consume the exact same API. Business logic and state machines live ONLY in the backend.

## Technology Stack
- **Frontend (Web):** Next.js (React) with TypeScript, TailwindCSS. Utilizing Server-Side Rendering (SSR) and Static Site Generation (SSG) for fast initial loads on low-bandwidth networks.
- **Backend:** Node.js (NestJS or Express) with TypeScript. *(Note: If using Next.js API routes as the backend, specify that here).*
- **Database:** **MySQL 8.0+**. Must use the InnoDB storage engine for ACID compliance and row-level locking.
- **ORM:** Prisma, TypeORM, or Sequelize (configured strictly for MySQL).
- **Background Jobs:** BullMQ / Redis (for EFRIS syncing, email/SMS notifications).
- **File Storage:** MinIO (self-hosted) or S3-compatible storage (must comply with Uganda data residency).

## Core Design Principles
1. **State-Driven**: Orders and Payments are strictly state-machine driven. No direct database updates from the UI; all changes must go through backend service methods.
2. **Auditability**: Every critical action (order creation, payment upload, status change) must log the `user_id`, `timestamp`, and `previous_state`.
3. **Idempotency**: Payment proof uploads and order creations must be idempotent to prevent duplicate processing.