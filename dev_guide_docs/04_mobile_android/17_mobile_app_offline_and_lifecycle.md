# Android App: Offline Sync, Lifecycle & Security
*(strictly to your Android/Kotlin Developers. This is their rulebook for offline sync and app security.)*

## 1. Offline Sync Logic
* Local Queue: Users can build and submit orders or payment proofs while offline. These are queued locally.
* Auto-Sync: The app must automatically sync the queue to the backend API once network connectivity is restored.
* Timestamp Rule: If a client submits an action offline, the app timestamps the local action. Upon sync, the backend applies the server-side timestamp for official processing, but the app must send and the backend must retain the local timestamp in the audit log for transparency.
* Offline Caching: The app must cache recent order history (last 30 days) and current account statements locally for offline viewing.

## 2. Camera & Image Handling
* Direct Capture: The app must integrate with the device camera to capture payment proofs directly.
* Compression: Images must be automatically compressed locally before upload to save mobile data bundles and ensure fast transmission.

## 3. App Lifecycle Management
* Force Update: The Admin panel can trigger a "Force Update" prompt on the Android app for critical security patches. The app must block usage until updated.
* Push Notifications: Must support alerts for order status changes, payment reconciliation, and new statements.
* Device Tokens: Must securely register and store mobile device tokens for targeted push notifications.

## 4. Mobile Security Constraints
* API Only: The Android app must NEVER connect directly to the database. All communication routes through the secure Backend API.
* SSL Pinning: The app must implement SSL Certificate Pinning to prevent Man-in-the-Middle attacks.
* Secure Storage: Authentication tokens must be stored using the Android Keystore or EncryptedSharedPreferences. Never use standard SharedPreferences for sensitive data.