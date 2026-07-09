# Information Architecture & User Journeys
*(For the Product, Backend, and Lead Devs to understand routing, database relationships, and user flows.)*

## 1. Web Portal Site Map (Client)
* Dashboard: Quick stats, quick actions, recent orders.
* Catalog: All cement categories, category detail, add to cart.
* Cart/Checkout: Summary, delivery scheduling, transport mode, review, submit.
* Orders: All orders, order detail (timeline, items, delivery, payment, URA invoice).
* Payments: History, upload new proof, payment methods.
* Statements: Account statement, download PDF, outstanding balance.
* Documents: Invoices, delivery notes, contracts.
* Settings: Profile, company details (TIN), security (MFA), notifications.

## 2. Web Portal Site Map (Admin)
* Executive Dashboard: KPIs, charts, alerts.
* Orders Management: All orders, pending approvals, bulk actions.
* Payments & Reconciliation: Pending queue, reconcile/reject workflow, URA status.
* Delivery & Dispatch: Calendar, dispatch queue, one-click dispatch to Yaobai.
* Catalog Management: Categories, pricing adjustments, URA tax mapping.
* Client Management: All clients, bulk import, onboarding.
* Reports: Sales, URA tax, regional analysis, exports.
* System Settings: User management, roles, mobile app config, integrations.

## 3. Android App Navigation
* Bottom Navigation Tabs: Home, Catalog, Orders, Account.
* Floating Action Button (FAB): "New Order" (bottom right).
* Order Flow: Cart, Delivery Scheduling, Review, Confirmation.
* Payment Flow: Select order, camera capture, preview, upload.
* Sync States: Online indicator, offline banner, syncing animation, error retry.

## 4. Key User Personas
* Site Manager Musa (Mobile): Works outdoors, intermittent network, needs fast one-handed ordering and offline capabilities.
* Procurement Officer Patricia (Web): Office environment, stable internet, places large bulk orders, needs detailed reports and URA invoices.
* Finance Officer Florence (Web Admin): Reconciles 50-100 payments daily, needs side-by-side view of order and payment proof, keyboard shortcuts.
* Operations Manager Oscar (Web Admin): Coordinates deliveries, needs visual calendar, one-click bulk dispatch to Yaobai plant.
* Managing Director Jonard (Web Admin): Needs high-level KPI dashboard, trend charts, and mobile access for quick checks.

## 5. Core User Journey: Client Places Order (Web)
1. Need Recognition: Realizes project needs cement.
2. Login: Opens portal, enters credentials.
3. Browse Catalog: Navigates to Catalog, views CEM I.
4. Add to Cart: Selects quantity, views real-time price calculator.
5. Schedule Delivery: Picks date, selects Yaobai transport.
6. Review & Submit: Confirms details, clicks Submit.
7. Payment: Makes bank transfer, uploads proof via camera/file.
8. Tracking: Checks status timeline until delivery.