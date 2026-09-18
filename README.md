# Private Cloud Music Player

A private, single-user cloud-native music platform being designed and implemented on AWS. The project focuses on secure media delivery, reproducible infrastructure, strong access controls, automation, and operational reliability.

**Current status:** architecture and repository foundations are established. CI workflows, the frontend/backend scaffolds, PowerShell ingestion tooling, security documentation, and the first infrastructure work package are implemented in source. The AWS infrastructure itself is **not yet deployed from this repository**; WP-01 remains the next implementation milestone.

## Current Implementation Status

| Area | Status |
|---|---|
| Architecture and design baseline | Established |
| Security / threat model | Documented |
| GitHub Actions CI | Implemented |
| PowerShell ingestion manifest tooling | Implemented |
| React / TypeScript frontend scaffold | Implemented |
| Python backend package / test scaffold | Implemented |
| Terraform repository structure | Scaffolded |
| Terraform resource implementation | Pending WP-01 |
| AWS infrastructure deployment | Not yet implemented from this repo |
| WP-01 secure-media validation | Pending |
| Cognito / API / Lambda / DynamoDB application layer | Planned |
| Production deployment | Not claimed |

## Engineering Goals

- Keep the music library private and single-user.
- Preserve lossless archival masters, preferably FLAC.
- Deliver protected media through CloudFront without exposing S3 directly.
- Manage AWS infrastructure with Terraform.
- Prefer serverless AWS services where practical to reduce idle cost.
- Provide a React/TypeScript web player and Python backend.
- Support PowerShell-based ingestion from a local Windows workstation.
- Maintain integrity metadata such as SHA-256 checksums.
- Use repeatable validation, deployment, and recovery practices.

## Target Architecture

```text
Web / PWA
  |
  +--> Cognito (login + MFA)
  |
  +--> API Gateway --> Lambda --> DynamoDB
  |                       |
  |                       +--> CloudFront signed playback URL
  |
  +--> CloudFront --> private S3 media origin via OAC
```

Regional AWS services target `us-west-2`; CloudFront is global.

This diagram represents the **target architecture**, not a claim that every component is currently deployed.

## Implemented Today

### PowerShell ingestion tooling

`ingestion/powershell/Import-Album.ps1` currently:

- validates the supplied album directory;
- discovers supported audio files;
- calculates SHA-256 hashes;
- records file sizes and track order;
- generates a structured JSON manifest;
- uses `SupportsShouldProcess` for safer file creation;
- stops on errors rather than silently continuing.

### CI / repository automation

GitHub Actions currently provides:

- Python package installation, Ruff linting, and Pytest execution;
- React / TypeScript build validation;
- Terraform formatting checks when Terraform files are present.

The Terraform workflow intentionally reports that the repository is still a scaffold when no `.tf` files exist.

### Application scaffolds

- React / TypeScript / Vite frontend scaffold
- Python backend package and test scaffold
- data model
- API design
- ingestion design
- disaster-recovery design
- threat model
- security model
- WP-01 acceptance criteria

## Repository Structure

```text
docs/                    Architecture, security, API, ingestion, DR, threat model
infrastructure/          Terraform environments and reusable-module scaffold
backend/                 Python/Lambda application scaffold
frontend/                React/TypeScript player scaffold
ingestion/               Local import tooling and schemas
scripts/                 Bootstrap/deployment helper scripts
.github/workflows/       CI validation
```

## Next Implementation Milestone

`WP-01 — Secure Media Foundation` is the first AWS infrastructure implementation increment.

It is intended to establish and validate:

1. Terraform remote-state foundation.
2. Private media S3 bucket.
3. S3 Block Public Access.
4. CloudFront distribution.
5. Origin Access Control.
6. Trusted key group / public key.
7. Signed URL validation.
8. Direct S3 request returns `403`.
9. Unsigned CloudFront request returns `403`.
10. Signed CloudFront request returns `200`.
11. Byte-range request returns `206`.
12. Safe teardown / recreate documentation for the dev environment.

See `docs/work-packages/wp-01-secure-media-foundation.md`.

## Evidence Classification

This repository is an **independent cloud engineering project**.

It demonstrates architecture, code, automation, security design, CI, PowerShell tooling, and implementation planning. It should not be interpreted as employer production AWS tenure or as evidence that all target-state AWS services are already deployed.

Planned architecture, implemented source artifacts, and future deployment evidence are kept distinct.

## What This Demonstrates

This project is intended to demonstrate how I approach cloud-platform work:

- define architecture before deployment;
- separate implemented state from target state;
- use Infrastructure as Code for reproducibility;
- apply least-privilege and private-origin patterns;
- build CI checks early;
- use PowerShell for practical automation;
- define measurable acceptance tests;
- plan for backup, recovery, and observability;
- preserve evidence integrity during implementation.

## Security and Legal Boundary

This is a private personal system, not a public streaming service. Public registration, account sharing, and media sharing are intentionally out of scope.

No copyrighted media, production credentials, private keys, Terraform state, or long-lived AWS access keys should be committed.

See `SECURITY.md`.

## Technical Review Path

For an employer or technical reviewer, start with:

1. `README.md`
2. `docs/architecture.md`
3. `docs/security-model.md`
4. `docs/threat-model.md`
5. `docs/work-packages/wp-01-secure-media-foundation.md`
6. `ingestion/powershell/Import-Album.ps1`
7. `.github/workflows/`
