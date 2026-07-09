
---

### 4. `04_auth_and_rbac.md`
*Defines roles and permissions.*

```markdown
# Authentication & Role-Based Access Control (RBAC)

## Authentication
- **Mechanism**: JWT (JSON Web Tokens) with short-lived Access Tokens (15 mins) and longer-lived Refresh Tokens (7 days).
- **Client Portal**: Clients log in using email/password + optional 2FA (SMS via local Ugandan gateway like Beem or AfricasTalking).
- **JCIL Admin**: Internal staff log in via SSO or strict email/password.

## Roles & Permissions
Implement a strict RBAC model. Do not use hardcoded role checks in controllers; use middleware/decorators.

### 1. Client User (Construction/Wholesaler)
- Can view own company profile.
- Can create, submit, and manage own orders.
- Can upload payment proofs.
- Can view own invoices and statements.
- *Cannot* view other clients' data.

### 2. JCIL Sales/Admin
- Can view all orders.
- Can adjust pricing (create quotes).
- Can schedule deliveries.
- Can view client statements.

### 3. JCIL Finance
- Can view all payments and uploaded proofs.
- Can mark payments as `RECONCILED` or `REJECTED`.
- Can generate and export financial reports.
- *Cannot* alter order quantities or base pricing.

### 4. JCIL Super Admin
- Full access. Can manage users, roles, system settings, and base pricing.