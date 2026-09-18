# Security Model

## Status

This document describes the **target security model** for the Private Cloud Music Player.

Some controls are already represented in repository source or CI, while the AWS runtime components remain pending implementation through WP-01 and later work packages. Nothing in this document should be read as proof that every target-state service is currently deployed.

## Authentication

The target design uses Amazon Cognito User Pools for the owner identity.

Intended properties:

- no public self-registration;
- one administrator-created owner account initially;
- required TOTP MFA;
- OAuth Authorization Code + PKCE.

## Authorization

Protected API routes are intended to require valid Cognito JWTs.

Media playback is designed to be authorized by the backend, which returns short-lived CloudFront signed URLs for individual objects.

## S3 Boundary

Required deployed-state controls:

- S3 Block Public Access enabled for protected buckets;
- Object Ownership set to `BucketOwnerEnforced`;
- protected media bucket policy grants CloudFront access through Origin Access Control only;
- no anonymous direct media reads.

Expected WP-01 validation behavior:

- Direct S3 media request: `403`.
- Unsigned protected CloudFront media request: `403`.
- Valid signed CloudFront media request: `200`.
- Valid range request against protected media: `206`.

These HTTP results are acceptance targets until they are demonstrated and recorded by implementation evidence.

## Signing Material

CloudFront private signing keys must never be committed.

Target handling:

- private signing material stored in AWS Secrets Manager or another approved secure secret store;
- retrieval granted only to the playback-signing runtime role;
- CloudFront receives only the corresponding public key through a trusted key group.

## IAM

Each runtime role should receive only the actions and resources required for its function.

Example: playback code may require metadata-read and signing-secret access, but should not require media deletion or IAM-administration permissions.

## CI/CD Identity

Current CI workflows use minimal GitHub repository permissions.

When AWS deployment automation is introduced, GitHub Actions should use OIDC federation to assume narrowly scoped AWS roles. Long-lived AWS access keys are prohibited in repository secrets.

## Data Protection

Target controls include:

- S3 default encryption;
- versioning where recovery requirements justify it;
- protected Terraform state;
- checksum-based media integrity verification.

SSE-S3 is acceptable for the initial personal deployment. SSE-KMS may be introduced when key-level control is justified.

## Account Controls

Required AWS account-level controls include:

- root-account MFA;
- least-privilege IAM;
- no committed production credentials;
- no committed private keys;
- no committed Terraform state;
- no committed local environment secrets.

## Evidence Boundary

Architecture and security requirements are not equivalent to deployment proof.

A control becomes implemented evidence only after the corresponding configuration exists and its validation has been recorded.
