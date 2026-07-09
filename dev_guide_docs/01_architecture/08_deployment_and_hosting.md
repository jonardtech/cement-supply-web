# Deployment, Infrastructure & Data Residency

## Data Residency Constraint
**CRITICAL**: By Ugandan law and JCIL policy, all client data, financial records, and order data MUST reside physically within Uganda. 

## Hosting Strategy
1. **Primary Option (Local Data Center)**: Host the backend, database, and file storage in a Tier 3 local data center (e.g., Roke Telkom, Liquid Intelligent Technologies, or MTN Uganda Data Center).
2. **Secondary Option (Compliant Cloud)**: If using a cloud provider, ensure the specific region complies with the Uganda Data Protection and Privacy Act 2019. *(Note: AWS/Azure do not currently have physical regions in Uganda, so local DC or a specialized African cloud provider like Paragon or Africa Data Centres is required).*

## CI/CD Pipeline
- **Repository**: GitHub / GitLab.
- **Pipeline**: GitHub Actions / GitLab CI.
- **Steps**: Lint -> Test -> Build -> Deploy to Staging -> Manual Approval -> Deploy to Production.

## Environment Variables
Never commit `.env` files. Use a secrets manager or secure environment variable injection in the CI/CD pipeline.
Required keys include:
- `DB_URL` (PostgreSQL connection string)
- `JWT_SECRET`
- `URA_EFRIS_TIN`, `URA_EFRIS_DEVICE_ID`, `URA_EFRIS_API_KEY`
- `STORAGE_BUCKET_ENDPOINT`, `STORAGE_ACCESS_KEY`