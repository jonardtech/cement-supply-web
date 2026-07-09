# Web Portal & Admin Screen Specifications
*(For Next.js Frontend Developers.)*

## 1. Client Login Screen
* Centered card, max-width 400px.
* JCIL logo at top (64px height).
* Email input with autofocus and validation.
* Password input with show/hide toggle.
* "Forgot password?" link right-aligned.
* Primary button full-width, 48px height.
* Loading state shows spinner inside button.

## 2. Client Dashboard
* Time-aware greeting ("Good morning, Patricia").
* 3 Stat Cards in a row: Active Orders, Outstanding Balance, This Month Volume. Include trend indicators (up/down arrows with color).
* Quick Actions: 3 prominent cards (New Order, Upload Payment, Download Statements).
* Recent Orders: Table showing last 5 orders. Clickable rows.
* Notification Bell: Shows unread count, dropdown with recent alerts.

## 3. Catalog Page
* Grid Layout: 4 columns desktop, 2 tablet, 1 mobile.
* Category Cards: Image (4:3 ratio), name, description, price, "View Details" button.
* Hover State: Slight elevation, "Add to Cart" button appears.
* Search: Real-time search with autocomplete.
* Filters: Category, price range, sort order.

## 4. Order Detail Page
* Status Timeline: Horizontal stepper with dates, color-coded.
* Two-Column Layout: Order items on left, delivery info on right (stacks on mobile).
* Pricing Breakdown: Itemized list showing base price, volume discount, region surcharge, and VAT (18%).
* Payment Section: Status badge, proof link, URA invoice download button.
* Contextual Actions: Reorder, Download All Documents, Contact Support.

## 5. Payment Upload Modal
* Drag-and-drop zone with visual feedback on hover.
* Camera capture button (mobile-only).
* File validation: PDF, JPG, PNG (max 5MB).
* Progress indicator bar during upload.
* Optional Reference Number and Notes fields.

## 6. Admin Executive Dashboard
* 4 KPI Cards: Revenue, Volume (bags), Orders, Unreconciled Payments.
* Interactive Charts: Sales by category (bar chart), Regional distribution (pie chart).
* Top 10 Clients: Ranked list with revenue, tappable for detail.
* Alerts Section: Color-coded warnings for unreconciled payments or pending approvals.

## 7. Admin Payment Reconciliation Queue
* Split View: Queue list on top/left, detail view on bottom/right.
* Bulk Actions: Checkboxes to select multiple payments and reconcile together.
* Image Viewer: Zoom, rotate, and enhance tools for payment proofs.
* Keyboard Shortcuts: R (reconcile), X (reject), N (next), P (previous).
* Auto-Match: System highlights matching orders based on amount and client.

## 8. Admin Delivery Calendar
* Calendar Views: Month, Week, Day.
* Order Badges: Show count of orders on each day.
* Color Coding: Yaobai transport (blue), Client transport (green).
* Click Day: Opens list of orders for that specific day.
* Bulk Dispatch: Select multiple orders and dispatch to Yaobai with one click.