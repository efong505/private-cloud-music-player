# Private Cloud Music Player — Production Blueprint

> **Status:** Target-state architecture blueprint. This document describes intended production architecture and design decisions. It does **not** assert that every listed AWS component is currently deployed. The repository currently contains architecture, application/CI scaffolding, PowerShell ingestion tooling, and work-package definitions; WP-01 remains the first infrastructure implementation milestone.

This document captures the initial design baseline for the project.

## 1. Target architecture
Private S3 origins, CloudFront delivery, Cognito authentication, API Gateway, Lambda, DynamoDB, Route 53/ACM, and automated ingestion.

## 2. Playback authorization
Use short-lived CloudFront signed URLs for individual tracks in the first production version. Signed cookies remain an option for broader resource groups later.

## 3. Authentication
Amazon Cognito User Pool, no self-registration, one initial owner account, required TOTP MFA, and Authorization Code + PKCE.

## 4. Storage architecture
Separate private buckets for frontend assets, archival originals, streaming copies, artwork, ingestion staging, and optional logs.

## 5. Master-format strategy
Preserve CD masters as FLAC, normally 44.1 kHz / 16-bit for standard audio CDs. Derived AAC/Opus/MP3 variants may be generated later.

## 6. CD ingestion
Rip locally, extract metadata, compute SHA-256, stage locally, upload to the ingestion path, validate, normalize artwork, and index metadata.

## 7. Integrity checking
Store SHA-256, byte size, codec, sample rate, bit depth, and channels for each track.

## 8. Metadata database
Use DynamoDB for artists, albums, tracks, playlists, favorites, play history, and library statistics. S3 keys are references, not the catalog.

## 9. API
Expose authenticated REST endpoints for identity, artists, albums, tracks, playback authorization, playlists, favorites, history, recent plays, search, and import registration.

## 10. Playback authorization flow
User presses play, frontend calls the protected API, API validates JWT and authorization, backend generates a short-lived CloudFront signed URL, and CloudFront retrieves the object from private S3 through OAC.

## 11. Audio seeking
Support HTTP byte-range requests so seeking does not require re-downloading an entire track.

## 12. Frontend
React + TypeScript + Vite, with a browser-first player and room for TanStack Query, React Router, PWA capabilities, and Media Session API later.

## 13. Search
Start with normalized searchable fields in DynamoDB. Do not add OpenSearch until scale or fuzzy-search requirements justify it.

## 14. Album artwork
Keep original artwork plus smaller WebP derivatives for efficient UI display.

## 15. Import automation
Use idempotent states such as UPLOADING, VALIDATING, PROCESSING, READY, and FAILED. Retries must not create duplicate tracks.

## 16. Heavy transcoding
Use Lambda for lightweight metadata work. Use ECS/Fargate for heavier FFmpeg transcoding if needed.

## 17. Repository structure
Separate docs, infrastructure, backend, frontend, ingestion, scripts, and GitHub Actions workflows.

## 18. Terraform
Terraform is intended to own S3, CloudFront, OAC, CloudFront key groups/public keys, Cognito, API Gateway, Lambda, DynamoDB, IAM, Route 53, ACM, CloudWatch, SQS/DLQs, and optional ECS/Fargate resources.

**Current implementation note:** the repository structure and validation workflow are in place, but Terraform resource definitions have not yet been added.

## 19. Secret handling
Never commit CloudFront private signing keys. Store sensitive signing material in AWS Secrets Manager with narrowly scoped retrieval permissions.

## 20. IAM design
Apply least privilege to each Lambda, workflow, and deployment role. Playback code should not have unrelated destructive or IAM permissions.

## 21. Observability
Use CloudWatch for API errors, Lambda failures/throttling, DynamoDB throttling, ingestion failures, DLQ depth, and authentication anomalies.

## 22. Security threat model
Primary controls address public-bucket mistakes, direct-origin access, leaked playback URLs, stolen credentials, exposed signing keys, accidental deletion, corruption, failed ingestion, and AWS account compromise.

## 23. Backups
Maintain physical media where available, a local archive, and an S3 archive. Use versioning and integrity checks. Derived streaming copies should be reproducible.

## 24. CI/CD
Current repository CI validates Python code, frontend builds, and Terraform formatting when Terraform files are present.

Future AWS deployment automation should authenticate through GitHub Actions OIDC and narrowly scoped roles.

## 25. Environments
Begin with dev and prod only. Avoid unnecessary environment sprawl.

## 26. Cost philosophy
Prefer serverless/on-demand services. Avoid 24/7 EC2, RDS, EKS, NAT Gateway, or OpenSearch until a concrete requirement justifies them.

## 27. MVP
Cognito login/MFA; artists, albums, tracks, artwork; FLAC playback; seeking; previous/next; search; favorites; playlists; recently played; private S3; CloudFront; signed URLs; DynamoDB; Terraform; GitHub Actions; PowerShell album import; monitoring.

This is the target MVP scope, not a statement that all features are already complete.

## 28. Phase 2
PWA, Android client, gapless playback, ReplayGain, AAC/Opus variants, smart playlists, richer search, persistent queue, listening statistics, car mode, and casting.

## 29. Future enhancements
Potential future enhancements may include natural-language library queries, duplicate detection, collection-maintenance assistance, richer recommendations, and listening-history exploration. Any such capability would remain constrained to authorized application data and would not receive unrestricted AWS access.

## 30. Project boundary
This is a private, single-user personal music-management system. Public registration, copyrighted-media sharing, resale, sublicensing, and public streaming are intentionally unsupported.

## 31. Recommended stack and starting point
Terraform, `us-west-2`, React, TypeScript, Vite, Python, API Gateway HTTP API, Lambda, Cognito, DynamoDB, S3, CloudFront, OAC, signed URLs, Secrets Manager, Route 53, ACM, CloudWatch, optional ECS/Fargate, GitHub Actions OIDC, PowerShell, FFmpeg, and FLAC masters.

The first implementation increment is `WP-01 — Secure Media Foundation`, which must prove private S3 access, CloudFront OAC, signed URLs, and range requests before application-layer development proceeds.
