# Private Cloud Music Player

A private, single-user, cloud-native personal music player built on AWS. The system stores lawfully possessed music in private S3 buckets, delivers audio through CloudFront, authenticates the owner with Amazon Cognito, and uses short-lived signed URLs for playback.

## Goals

- Keep the music library private and single-user.
- Preserve lossless archival masters, preferably FLAC.
- Stream securely through CloudFront without exposing S3 directly.
- Use Terraform for reproducible infrastructure.
- Use serverless AWS services where practical to minimize idle cost.
- Provide a React/TypeScript web player and Python backend.
- Support PowerShell-based ingestion from a local Windows workstation.
- Maintain integrity metadata such as SHA-256 checksums.

## Target architecture

```text
Web/PWA
  |
  +--> Cognito (login + MFA)
  |
  +--> API Gateway --> Lambda --> DynamoDB
  |                       |
  |                       +--> CloudFront signed playback URL
  |
  +--> CloudFront --> private S3 media origin via OAC
```

Primary regional resources target `us-west-2`; CloudFront is global.

## Repository structure

```text
docs/                    Architecture, security, API, ingestion, DR, threat model
infrastructure/          Terraform environments and reusable modules
backend/                 Python/Lambda application code
frontend/                React/TypeScript player
-ingestion/              Local import tooling and schemas
scripts/                 Bootstrap/deployment helper scripts
.github/workflows/       CI/CD validation
```

## MVP

The first release targets Cognito login/MFA, artists, albums, tracks, artwork, FLAC playback, seeking, playlists, favorites, recently played, private S3, CloudFront OAC, signed URLs, DynamoDB, Terraform, GitHub Actions, PowerShell album import, and CloudWatch monitoring.

## First work package

`WP-01 — Secure Media Foundation` proves the core media path before application development:

1. Terraform remote-state foundation.
2. Private media S3 bucket.
3. S3 Block Public Access.
4. CloudFront distribution.
5. Origin Access Control.
6. Trusted key group/public key.
7. Signed URL validation.
8. Direct S3 request returns `403`.
9. Unsigned CloudFront request returns `403`.
10. Signed CloudFront request returns `200`.
11. Range request returns `206`.

See `docs/work-packages/wp-01-secure-media-foundation.md`.

## Security and legal boundary

This is a private personal system, not a public streaming service. Public registration, account sharing, and media sharing are intentionally out of scope. See `SECURITY.md`.
