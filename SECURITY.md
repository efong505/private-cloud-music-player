# Security Policy

## Project Boundary

This repository defines and implements portions of a private, single-user personal music-management system.

It is not designed to distribute, sublicense, publicly perform, share, sell, or provide third-party access to copyrighted audio content. All stored media must be lawfully possessed by the operator.

Public registration and media sharing are intentionally unsupported.

## Current-State Note

The repository currently contains the security architecture, threat model, CI scaffolding, application scaffolds, and local ingestion tooling. The target AWS infrastructure is not yet fully implemented or deployed from this repository.

The controls below are therefore written as **required security properties for deployed components** unless a control is explicitly represented by current source code or CI configuration.

## Security Requirements

- All deployed media buckets must use S3 Block Public Access.
- Protected media objects must be reachable through CloudFront Origin Access Control (OAC), not anonymous direct S3 access.
- Playback authorization must use short-lived CloudFront signed URLs or another equivalently bounded mechanism.
- The target application authentication design uses Amazon Cognito with MFA.
- Protected API routes must validate appropriate authentication tokens before protected backend execution.
- IAM policies must follow least privilege.
- CloudFront signing private keys must remain outside source control and should be stored in an approved secrets-management mechanism such as AWS Secrets Manager.
- GitHub Actions deployment identities should use AWS OIDC federation rather than long-lived AWS access keys.
- Production secrets, credentials, private keys, copyrighted media, Terraform state, and generated sensitive material must never be committed.

## Repository Controls Already Present

The current repository already includes:

- GitHub Actions with read-only repository permissions for CI;
- no committed long-lived AWS access keys in the reviewed source;
- `.gitignore` / repository guidance prohibiting secrets and Terraform state;
- a threat model;
- a documented security model;
- WP-01 acceptance tests for S3, CloudFront, signing, and Terraform validation;
- PowerShell ingestion code that performs local hashing without uploading content.

## Validation Expectations

When WP-01 is implemented, evidence should confirm at minimum:

- direct protected S3 request returns `403`;
- unsigned protected CloudFront request returns `403`;
- valid signed CloudFront request returns `200`;
- valid byte-range request returns `206`;
- S3 Block Public Access is enabled;
- the bucket policy does not permit anonymous reads;
- signing private material is absent from Git history and Terraform state.

## Reporting

For this personal project, security findings should be recorded privately by the repository owner before remediation details are published.
