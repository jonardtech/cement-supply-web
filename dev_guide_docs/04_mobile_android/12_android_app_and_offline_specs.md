# Android App & Offline-First Specifications
*(For Android/Kotlin Developers)*

## 1. Mobile Design Principles
* Thumb Zone Design: Primary actions in the bottom third of the screen. Navigation at the bottom.
* One-Handed Operation: All critical actions reachable with the thumb. FAB for primary action.
* Field-Ready: Large touch targets (minimum 48px, recommended 56px). High contrast for outdoor visibility.

## 2. Key Screen Specifications
### Splash & Login
* Splash: Full-screen brand color, centered logo, max 2 seconds display. Checks for forced updates.
* Login: Email keyboard for email field. Show/hide toggle for password. Biometric login button shown if previously enabled.

### Home Screen (Dashboard)
* Top Bar: Hamburger menu (left), notification bell with badge (right), avatar (far right).
* Sync Status: Green dot (online), yellow dot (offline), animated (syncing).
* Stat Cards: 2 per row, large numbers, tappable.
* Bottom Nav: 4 tabs (Home, Catalog, Orders, Account).
* FAB: Floating action button for "New Order" (bottom-right).

### Order Placement Flow
* Step 1 (Cart): List items with quantity steppers. Show subtotal, discounts, and VAT.
* Step 2 (Delivery): Date picker, transport mode radio buttons, delivery address.
* Step 3 (Review): Summary of items and delivery details. Total amount.
* Step 4 (Confirmation): Success checkmark, order number, "View Order" and "Back to Home" buttons.

### Camera Payment Upload
* Bottom sheet options: Take Photo, Choose from Gallery, Upload PDF.
* Camera Overlay: Guide frame to align receipt. Tips for good lighting.
* Auto-compression: Compress image to under 500KB before upload.

## 3. Offline-First UX Requirements
### Indicators
* Online: Green dot in top bar.
* Offline: Yellow banner at top ("Offline Mode - Changes will sync when connected").
* Syncing: Animated sync icon with "Syncing X items..." message.
* Error: Red banner with "Tap to retry" button.

### Offline Capabilities
* Available Offline: View cached catalog, view order history (last 30 days), place new orders (queued locally), upload payment proofs (queued locally).
* Not Available Offline: Real-time status updates, new catalog items, live support, URA invoice downloads.

### Sync Behavior
* Automatic Sync: Triggers when network returns. Runs in background. Retries with exponential backoff on failure.
* Conflict Resolution: Server timestamp takes precedence. Local timestamp preserved in audit log.
* Data Integrity: Use SHA-256 hash verification. Failed syncs must not corrupt local data. Queue must persist across app restarts.