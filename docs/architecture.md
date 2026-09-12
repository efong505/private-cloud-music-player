# Architecture

## Objective

Build a private, single-user music system that stores archival audio in Amazon S3 and delivers protected playback through CloudFront.

## Core request flow

```text
Browser / PWA
   |
   +--> Cognito User Pool
   |      \--> Authorization Code + PKCE, MFA
   |
   +--> API Gateway HTTP API
           |
           +--> Lambda services
                   |
                   +--> DynamoDB metadata
                   +--> Secrets Manager signing material
                   +--> CloudFront signed URL

Browser audio element
   |
   +--> CloudFront
           |
           +--> Origin Access Control
                   |
                   +--> private S3 streaming bucket
```

## Storage domains

- Web frontend bucket: private origin behind CloudFront.
- Original media bucket: archival FLAC masters.
- Streaming media bucket: playback-ready objects.
- Artwork bucket: normalized cover assets.
- Ingestion bucket: temporary uploads/manifests.
- Logging bucket: optional access/security logs.

## Primary AWS services

- Amazon S3
- Amazon CloudFront
- CloudFront Origin Access Control
- Amazon Cognito
- Amazon API Gateway
- AWS Lambda
- Amazon DynamoDB
- AWS Secrets Manager
- Amazon Route 53
- AWS Certificate Manager
- Amazon CloudWatch
- Amazon SQS + DLQ where asynchronous processing is needed
- Amazon ECS/Fargate for heavier transcoding if introduced later

## Deployment model

Regional services target `us-west-2`. CloudFront remains global. Infrastructure is managed through Terraform. GitHub Actions uses OIDC federation to AWS.

## Design constraints

- Single-user by default.
- No public registration.
- No media sharing.
- No direct public S3 access.
- Short-lived playback authorization.
- Lossless archival masters are preserved separately from derived streaming files.
- The application API, not the frontend, is the authorization authority.
