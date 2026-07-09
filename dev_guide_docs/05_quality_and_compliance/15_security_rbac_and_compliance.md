# Security, RBAC & Compliance Requirements
*(For the Backend, Frontend, and QA teams. This defines who can do what and the legal constraints.)*

## 1. Role-Based Access Control (RBAC) Matrix
The system must enforce strict access control. Users only see data and buttons relevant to their role.

* Client (Wholesaler/Project): Browse catalog, place orders, upload proofs, view history, download URA invoices/statements. (Web & Mobile)
* JCIL Finance: View uploaded proofs, reconcile/reject payments, generate financial reports. (Web Admin)
* JCIL Operations: Manage delivery schedules, approve orders, trigger Yaobai email dispatch. (Web Admin)
* JCIL Management/Admin: Full access. Pricing adjustments, client data seeding, view audit logs, executive dashboards. (Web Admin)
* System Admin (IT): Manage user accounts, system config, security settings, mobile app force-updates. Cannot modify financial or pricing data. (Web Admin)

## 2. Authentication & Session Rules
* Secure login, password reset, and session timeout features are mandatory.
* First-Time Login: New clients must digitally accept the JCIL Terms of Service and Privacy Policy via a mandatory checkbox.
* Mobile Biometrics: Android app must support Fingerprint/Face ID after the initial password login.
* Mobile Session Timeout: Strict automatic timeout (e.g., 15 minutes of inactivity) requiring re-authentication.

## 3. Audit Logging Requirements
* The system must maintain an immutable audit log.
* Every critical system event must record: User ID, action performed, and exact timestamp.
* The Admin dashboard must include a dedicated, searchable interface to view these logs.
* Logs cannot be edited or deleted by any user, including System Admins.

## 4. Legal & Data Compliance
* Uganda Data Protection Act 2019: Full compliance is mandatory.
* Data Retention: All financial records, URA invoices, and audit logs must be retained for a minimum of 10 years.
* Hosting: Architecture must support a hybrid model, keeping highly sensitive data on local Uganda servers to ensure data sovereignty.