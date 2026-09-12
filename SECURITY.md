# Security Policy

## Project boundary

This repository implements a private, single-user personal music-management system. It is not designed to distribute, sublicense, publicly perform, share, sell, or provide third-party access to copyrighted audio content. All stored media must be lawfully possessed by the operator.

Public registration and media sharing are intentionally unsupported.

## Security principles

- S3 Block Public Access enabled for all media buckets.
- CloudFront Origin Access Control (OAC) is the only path to protected media objects.
- Playback uses short-lived CloudFront signed URLs.
- Cognito authentication with MFA protects the application.
- API Gateway validates JWTs before protected API execution.
- IAM policies follow least privilege.
- CloudFront signing private keys are stored outside source control in AWS Secrets Manager.
- GitHub Actions uses AWS OIDC federation; long-lived AWS access keys are prohibited.
- Production secrets, credentials, private keys, copyrighted media, and Terraform state are never committed.

## Reporting

For this personal project, security findings should be recorded privately by the repository owner before remediation details are published.
