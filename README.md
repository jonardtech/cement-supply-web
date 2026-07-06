# JCIL Cement Supply Web Platform

Welcome to the central repository for the **JCIL B2B Cement Distribution System**. 

This platform serves as the digital backbone for JCIL's distribution of **Yaobai Cement**, facilitating seamless order processing, delivery scheduling, and financial reconciliation between JCIL and our network of construction projects and wholesalers.

## Core Capabilities
- **Client Portal:** Self-serve ordering, invoice tracking, and statement management for B2B clients.
- **Admin & Operations Portal:** Internal tools for JCIL staff to manage pricing, schedule deliveries, and reconcile payments.
- **URA EFRIS Integration:** Automated, compliant e-invoicing and tax reporting.
- **Yaobai Plant Sync:** Secure sharing of confirmed orders with the manufacturing plant.

## Technology Stack
- **Backend API:** NestJS (Node.js/TypeScript) - Modular Monolith
- **Frontend Web:** Next.js (React/TypeScript) - SSR/SSG
- **Database:** MySQL 8.0+
- **Message Broker:** RabbitMQ (for resilient URA EFRIS integration)
- **Cache & Jobs:** Redis / BullMQ
