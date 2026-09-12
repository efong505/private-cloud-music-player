# Infrastructure

Terraform owns the AWS infrastructure for this project.

## Layout

```text
infrastructure/
  bootstrap/              Remote-state/bootstrap resources
  environments/
    dev/
    prod/
  modules/
    acm/
    api-gateway/
    cloudfront/
    cognito/
    dynamodb/
    iam/
    lambda/
    logging/
    route53/
    s3/
```

The first implementation target is `docs/work-packages/wp-01-secure-media-foundation.md`.

## Rules

- Target regional resources in `us-west-2` unless explicitly documented otherwise.
- Do not commit `.tfstate`, `.tfvars`, private keys, secrets, or generated credentials.
- Prefer reusable modules with explicit inputs/outputs.
- Use separate dev and prod state.
- GitHub Actions should authenticate to AWS with OIDC, never static access keys.
- Production apply should remain an explicit, controlled action.
