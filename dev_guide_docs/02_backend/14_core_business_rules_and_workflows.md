# Core Business Rules & Backend Workflows
*(Backend Developers. This is the strict logic that must be enforced in the API)*

## 1. Pricing Engine Logic
The backend must calculate the final price using this exact hierarchy. Never trust frontend price calculations.
* Formula: Final Price = (Category Base Price) + (Volume Adjustment) + (Region Adjustment).
* Base prices are stored in the database per cement category.
* Volume and Region adjustments are configured by Admins and applied dynamically at checkout.

## 2. Order Approval & Dispatch Rules
* Rule 1: An order cannot be dispatched to the Yaobai plant until two conditions are met:
  1. JCIL Admin approves the order.
  2. JCIL Finance marks the payment as "Reconciled".
* Rule 2: URA EFRIS tax invoices can only be generated after the order is approved and payment is reconciled.
* Rule 3: In Phase 1, there is no direct API connection to Yaobai. All order sharing must be executed via automated, standardized SMTP emails to the designated Yaobai plant email address.

## 3. Payment & Reconciliation Rules
* Default Terms: All new orders default to prepayment.
* Proof Upload: Clients upload Bank Transfer or Cheque proofs (PDF or image).
* Finance Workflow: Finance staff must view the proof, match it to the specific order, and explicitly mark it as "Reconciled" or "Rejected".
* Notifications: The system must automatically email JCIL Finance when a new proof is uploaded.

## 4. Unit & Catalog Rules
* Default Unit: 50kg bags.
* Flexibility: The database schema must support configurable units, but the UI defaults to bags.
* Catalog: Must support multiple categories (CEM I, CEM II, CEM IV) with descriptions of quality and construction use cases.