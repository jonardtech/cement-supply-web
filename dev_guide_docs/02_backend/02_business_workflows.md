# Business Workflows & State Machines
*(Crucial for developers to understand the exact lifecycle of orders and payments.)*

## 1. Order Lifecycle
Orders follow a strict state machine. Frontend UI must disable actions based on the current state.

**States:**
- `DRAFT`: Client is building the order. Not visible to JCIL.
- `SUBMITTED`: Client submitted. Awaiting JCIL pricing/validation.
- `QUOTED`: JCIL applied volume/region adjustments. Awaiting client approval.
- `CONFIRMED`: Client accepted quote. Triggers notification to Yaobai Plant.
- `SCHEDULED`: Delivery date and transport method (Yaobai vs Client) locked.
- `DISPATCHED`: Cement has left the plant/warehouse.
- `DELIVERED`: Client confirmed receipt (or auto-confirmed after X days).
- `CANCELLED`: Rejected or cancelled (requires admin override if past `SUBMITTED`).

**Rule:** Once an order is `CONFIRMED`, it cannot be cancelled via the client portal. Only JCIL Admins can cancel, which triggers a credit note workflow.

## 2. Payment & Reconciliation Lifecycle
Since Phase 1 relies on manual bank transfers/cheques:

**States:**
- `PENDING`: Order confirmed, awaiting payment (if prepay terms apply).
- `PROOF_UPLOADED`: Client uploaded bank slip/cheque image.
- `UNDER_REVIEW`: JCIL Finance team is verifying the proof against bank statements.
- `RECONCILED`: Finance matched the payment. Order moves to `SCHEDULED` (if prepay).
- `REJECTED`: Proof invalid (e.g., wrong amount, blurred image). Client notified to re-upload.

## 3. Pricing Engine Logic
Base price is stored in the DB. The backend calculates the final price using:
`Final Price = (Base Price * Quantity) + Regional Surcharge - Volume Discount + VAT (18%)`
*Devs: Do not calculate prices on the frontend. Frontend must request a quote from the backend to ensure security and consistency.*