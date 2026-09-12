# WP-01 — Secure Media Foundation

## Purpose

Prove the core private-media delivery architecture before application development.

## Scope

- Terraform remote-state foundation.
- Private S3 media bucket.
- S3 Block Public Access.
- S3 versioning and default encryption.
- CloudFront distribution.
- CloudFront Origin Access Control.
- CloudFront public key and trusted key group.
- Short-lived signed URL generation test path.
- Range-request validation.

## Acceptance tests

1. Direct S3 request for protected media returns `403`.
2. Unsigned CloudFront request for protected media returns `403`.
3. Valid signed CloudFront request returns `200`.
4. Valid byte-range request returns `206`.
5. S3 Block Public Access is enabled.
6. Bucket policy permits the intended CloudFront distribution and does not expose anonymous reads.
7. Signing private key is not present in Git history or Terraform state.
8. Terraform configuration passes `fmt` and `validate`.
9. Teardown/recreate is documented for the dev environment.

## Evidence

Record Terraform plan/apply output, relevant AWS resource identifiers, and HTTP response tests without committing credentials or private signing material.

## Exit criterion

WP-01 is complete only when all acceptance tests pass. Application-layer work may then build on the verified secure media plane.
