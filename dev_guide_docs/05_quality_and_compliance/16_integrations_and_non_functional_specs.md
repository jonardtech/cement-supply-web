# Integrations & Non-Functional Requirements (NFR)
*(For the DevOps, Backend, and Lead Developers. This covers external APIs and system performance targets.)*

## 1. External Integrations
* URA EFRIS API: Must integrate with sandbox and production environments to validate TINs and generate standardized electronic tax invoices.
* SMTP Email Service: Must integrate with a reliable provider for automated notifications and Yaobai dispatch emails.
* Push Notification Service: Must integrate with a service (e.g., Firebase Cloud Messaging) to deliver real-time alerts to the Android app.

## 2. Performance Targets
* Load Time: The client dashboard and order submissions must process in under 3 seconds under normal load.
* Responsiveness: The web portal must function flawlessly on mobile and desktop browsers.
* Mobile Stability: The Android app must maintain a crash-free session rate of 99% or higher.

## 3. Reliability & Disaster Recovery
* Uptime: System must achieve 99.9% uptime.
* Backups: Automated daily database backups are mandatory.
* Recovery: Must have a tested Disaster Recovery capability to restore data within 4 hours.

## 4. Mobile Compatibility
* Android Version: Must support devices running Android 8.0 (Oreo / API 26) and above.
* Screen Sizes: UI must be optimized for standard low-end smartphones up to tablets used by site managers.