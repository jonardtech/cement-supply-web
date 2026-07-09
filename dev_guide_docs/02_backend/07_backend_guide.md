# Backend Development Guide
*(Guidelines for the Node.js/Backend developers.)*

## Core Responsibilities
1. **Pricing Engine**: Centralized service that calculates final prices. Must handle edge cases (e.g., negative quantities, zero prices).
2. **File Handling**: Securely handle payment proof uploads. 
   - Validate file types (PDF, JPG, PNG only).
   - Scan for malware (if budget allows, or rely on storage provider).
   - Generate presigned URLs for the frontend to upload directly to storage, bypassing the backend to save memory.
3. **Yaobai Integration**: 
   - When an order hits `CONFIRMED`, trigger a webhook or background job to format the order data for Yaobai Plant.
   - *Note*: There is NO live inventory sync. We only push confirmed orders to Yaobai.

## Error Handling & Logging
- Use a centralized error handling middleware.
- Never expose stack traces or database errors to the frontend in production.
- Use a structured logger (e.g., `pino` or `winston`). Log `order_id`, `user_id`, and `action` for every critical mutation.

## Security
- **Rate Limiting**: Apply strict rate limits on login and payment upload endpoints.
- **SQL Injection**: Rely entirely on the ORM (Prisma/TypeORM). Never write raw SQL with string concatenation.
- **XSS**: Sanitize all text inputs (especially delivery notes and client names) before storing or rendering.

## MySQL Specific Guidelines & Gotchas
Since we are using MySQL, the backend team must adhere to the following database rules:

1. **Storage Engine:** Ensure all tables are created using the **InnoDB** engine. Do not use MyISAM. We need transaction support (ACID) and row-level locking for financial data.
2. **Character Set:** All databases, tables, and columns MUST use `utf8mb4` (not just `utf8`) and `utf8mb4_unicode_ci` collation. This is critical to prevent crashes when users enter special characters or emojis in delivery notes or client names.
3. **Strict Mode:** Enable `STRICT_TRANS_TABLES` in the MySQL configuration. This prevents MySQL from silently truncating data (e.g., silently cutting off a 256-character string to fit a 255-character column), which causes massive financial reconciliation bugs.
4. **JSON Columns:** If storing flexible pricing factors or metadata, use MySQL's native `JSON` data type (available in MySQL 5.7+), but ensure you use `JSON_EXTRACT` or generated columns for querying, as querying raw JSON in the `WHERE` clause can be slow without proper indexing.
5. **Primary Keys:** Decide on a strategy early. If using Auto-incrementing integers, ensure you are not exposing these IDs in the API (use UUIDs or hashed IDs in the API layer to prevent enumeration attacks). If using UUIDs, use `BINARY(16)` in MySQL for performance, not `VARCHAR(36)`.