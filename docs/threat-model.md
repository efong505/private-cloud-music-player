# Threat Model

## Assets

- Music archive and derived media.
- Cognito identity and tokens.
- CloudFront signing key.
- DynamoDB library metadata.
- AWS account and deployment roles.
- Terraform state.

## Principal threats and controls

| Threat | Primary control |
|---|---|
| Accidental public S3 | Block Public Access + BucketOwnerEnforced |
| Direct origin access | CloudFront OAC-only bucket policy |
| Leaked playback URL | Short expiration and scoped signed URL |
| Stolen password | Cognito TOTP MFA |
| Unauthenticated API access | API Gateway JWT authorizer |
| Signing-key exposure | Secrets Manager + least-privilege retrieval |
| Credential committed to Git | `.gitignore`, secret scanning, OIDC instead of static keys |
| Frontend compromise | Backend authorization remains authoritative |
| Accidental deletion | S3 versioning + backup strategy |
| Silent corruption | SHA-256 integrity verification |
| Failed asynchronous ingestion | Retry-safe processing + SQS DLQ where used |
| AWS account compromise | Root MFA and constrained IAM roles |

## Explicit non-goals

The initial system does not support public streaming, user-to-user sharing, public playlists, anonymous access, public sign-up, or multi-tenant authorization.
