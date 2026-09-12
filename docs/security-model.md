# Security Model

## Authentication

Amazon Cognito User Pools provides the owner identity. Self-registration is disabled. The intended initial state is one administrator-created user with required TOTP MFA and OAuth Authorization Code + PKCE.

## Authorization

Protected API routes require valid Cognito JWTs. Media playback is authorized by the backend, which returns short-lived CloudFront signed URLs for individual objects.

## S3 boundary

All buckets have Block Public Access enabled and Object Ownership set to BucketOwnerEnforced. Protected media buckets grant CloudFront access through Origin Access Control only.

Expected behavior:

- Direct S3 media request: `403`.
- Unsigned protected CloudFront media request: `403`.
- Valid signed CloudFront media request: `200`.
- Valid range request against protected media: `206`.

## Signing material

CloudFront private signing keys must never be committed. Store private signing material in AWS Secrets Manager and grant retrieval only to the playback-signing Lambda. CloudFront receives only the corresponding public key through a trusted key group.

## IAM

Each runtime role receives only required actions and resources. Example: playback code may read metadata and the signing secret, but does not need permission to delete media or manage IAM.

## CI/CD identity

GitHub Actions uses OIDC federation to assume narrowly scoped AWS roles. Long-lived AWS access keys are prohibited in repository secrets.

## Data protection

S3 default encryption is enabled. SSE-S3 is acceptable for the initial personal deployment; SSE-KMS may be introduced when key-level control is justified.

## Account controls

AWS root MFA is required. Production credentials, private keys, copyrighted media, Terraform state, and local environment secrets are excluded from source control.
