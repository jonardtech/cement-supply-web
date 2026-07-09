# JCIL CODMS (Cement Distribution & Order Management System)

Welcome to the official repository for the JCIL B2B Cement Distribution & Order Management System (CODMS). 

This system digitizes the sale, scheduling, and payment reconciliation of Yaobai Cement. It serves construction projects and wholesalers through a Web Platform and a Native Android Mobile Application, ensuring strict compliance with URA EFRIS tax regulations and the Uganda Data Protection and Privacy Act 2019.

## 🚀 Project Overview
* **Core Product:** B2B ordering, delivery scheduling, and payment reconciliation.
* **Platforms:** Web Portal (Next.js) for all users, Native Android App for field clients.
* **Database:** MySQL 8.0+ (InnoDB).
* **Key Integrations:** URA EFRIS (Tax Invoicing), SMTP (Yaobai Plant Dispatch).
* **Key Constraint:** All data must reside in Uganda (Data Sovereignty).

---

## 📚 Documentation Guide
All technical specifications, business rules, and design systems are located in the `dev_guide_docs/` directory. They are organized into subfolders by discipline.

### 🏗️ Architecture & Database
High-level system design, technology stack, and database schemas.
* [Database Schema & Info](./dev_guide_docs/00_database/about_db.md)
* [MySQL Schema (db.sql)](./dev_guide_docs/00_database/db.sql)
* [Architecture & Tech Stack](./dev_guide_docs/01_architecture/01_architecture_and_stack.md)
* [Deployment & Hosting (Uganda Data Residency)](./dev_guide_docs/01_architecture/08_deployment_and_hosting.md)

### ⚙️ Backend & Business Logic
API contracts, state machines, and core business rules for the Node.js backend.
* [Backend Development Guide & MySQL Gotchas](./dev_guide_docs/02_backend/07_backend_guide.md)
* [API Contracts & Endpoints](./dev_guide_docs/02_backend/03_api_contracts.md)
* [Core Business Rules (Pricing, Dispatch)](./dev_guide_docs/02_backend/14_core_business_rules_and_workflows.md)
* [Order & Payment State Machines](./dev_guide_docs/02_backend/02_business_workflows.md)
* [URA EFRIS Integration Guide](./dev_guide_docs/02_backend/05_ura_efris_compliance.md)

### 🌐 Frontend (Web Portal)
Next.js rendering strategies, UI components, and screen specifications.
* [Frontend Guide (Next.js SSR/CSR)](./dev_guide_docs/03_frontend_web/06_frontend_guide.md)
* [Design System, Brand & Colors](./dev_guide_docs/03_frontend_web/09_design_system_and_brand.md)
* [Information Architecture & User Journeys](./dev_guide_docs/03_frontend_web/10_information_architecture_and_journeys.md)
* [Web & Admin Screen Specifications](./dev_guide_docs/03_frontend_web/11_web_and_admin_screen_specs.md)

### 📱 Android Mobile App
Kotlin/Compose guidelines, offline-first sync logic, and mobile UI specs.
* [Android App & Offline UI Specs](./dev_guide_docs/04_mobile_android/12_android_app_and_offline_specs.md)
* [Offline Sync, Lifecycle & Security](./dev_guide_docs/04_mobile_android/17_mobile_app_offline_and_lifecycle.md)

### 🛡️ Quality, Security & Compliance
RBAC, legal compliance, accessibility, and testing protocols.
* [Security, RBAC & Legal Compliance](./dev_guide_docs/05_quality_and_compliance/15_security_rbac_and_compliance.md)
* [Integrations & Non-Functional Requirements](./dev_guide_docs/05_quality_and_compliance/16_integrations_and_non_functional_specs.md)
* [Accessibility (WCAG) & Usability Testing](./dev_guide_docs/05_quality_and_compliance/13_accessibility_interactions_and_testing.md)

---

## 🎯 Developer Onboarding: Where to Start?

**If you are a Backend Developer:**
1. Read the [Architecture & Tech Stack](./dev_guide_docs/01_architecture/01_architecture_and_stack.md).
2. Review the [MySQL Schema](./dev_guide_docs/00_database/db.sql) and [Backend Guide](./dev_guide_docs/02_backend/07_backend_guide.md).
3. Study the [Core Business Rules](./dev_guide_docs/02_backend/14_core_business_rules_and_workflows.md) and [State Machines](./dev_guide_docs/02_backend/02_business_workflows.md).

**If you are a Frontend (Next.js) Developer:**
1. Read the [Frontend Guide](./dev_guide_docs/03_frontend_web/06_frontend_guide.md) to understand our SSR/CSR strategy.
2. Review the [Design System](./dev_guide_docs/03_frontend_web/09_design_system_and_brand.md) for colors, typography, and components.
3. Check the [Screen Specifications](./dev_guide_docs/03_frontend_web/11_web_and_admin_screen_specs.md) for exact layout requirements.

**If you are an Android Developer:**
1. Read the [Android App Specs](./dev_guide_docs/04_mobile_android/12_android_app_and_offline_specs.md).
2. Study the [Offline Sync & Security](./dev_guide_docs/04_mobile_android/17_mobile_app_offline_and_lifecycle.md) document carefully, as offline logic and SSL pinning are critical.

**If you are in QA / Testing:**
1. Review the [Business Rules](./dev_guide_docs/02_backend/14_core_business_rules_and_workflows.md) to understand what to test.
2. Follow the [Accessibility & Usability Testing Plan](./dev_guide_docs/05_quality_and_compliance/13_accessibility_interactions_and_testing.md).

---

## ⚠️ Critical Project Constraints
* **Phase 1 Scope:** No Mobile Money, no iOS app, no live Yaobai API. Yaobai dispatch is strictly via automated SMTP email.
* **Data Sovereignty:** No client or financial data can be hosted outside of Uganda.
* **URA EFRIS:** All invoicing must strictly follow URA electronic fiscal receipting standards.
* **Offline-First:** The Android app must fully support building orders and capturing payment proofs without an active internet connection.

## 🤝 Contributing
Please ensure all code follows the standards outlined in the documentation. Pull requests must include updates to the relevant documentation if business logic or API contracts change.

---
**Project Manager / UX Lead:** Ssempebwa Paul  
**Project Sponsor:** Hon. Eng. Jonard Asiimwe  
**Last Updated:** July 2026