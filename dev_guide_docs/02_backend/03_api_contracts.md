# API Design & Contracts
*(Defines how the frontend and backend communicate.)*

## General Guidelines
- **Format**: JSON. All responses must follow a standard envelope:
  ```json
  {
    "success": true,
    "data": { ... },
    "meta": { "page": 1, "total": 50 },
    "errors": []
  }

- Versioning: URL-based versioning (e.g., `/api/v1/orders`).
- Pagination: Cursor-based for large lists (like transaction history), offset-based for admin tables.
- Filtering: Use query params (e.g., `?status=CONFIRMED&date_from=2026-01-01`).

### Key Endpoints (Phase 1)
**Orders**
- `POST /api/v1/orders` - Create draft order.
- `POST /api/v1/orders/:id/submit` - Submit for JCIL review.
- `POST /api/v1/orders/:id/approve-quote` - Client approves JCIL's adjusted price.
- `GET /api/v1/orders/:id/statements` - Get order timeline/audit log.

**Payments**
- `POST /api/v1/payments/upload-proof` - Multipart/form-data. Uploads bank slip. Returns payment_id.
- `POST /api/v1/payments/:id/link-to-order` - Links an uploaded proof to a specific order.
- `PATCH /api/v1/payments/:id/reconcile` - JCIL Finance Only. Marks payment as reconciled.

Client Portal
- `GET /api/v1/portal/dashboard` - Returns active orders, pending payments, total credit limit.
- `GET /api/v1/portal/statements` - Paginated account statement (invoices, payments, balances).
