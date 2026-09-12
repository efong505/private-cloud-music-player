# Disaster Recovery

## Recovery objective

The music library is an archive as well as an application data set. S3 must not be treated as the only copy.

Maintain:

1. Original physical media where available.
2. A local archival copy.
3. An S3 archival copy.

## Protection controls

- Enable S3 versioning on archival buckets.
- Retain SHA-256 integrity metadata for every track.
- Back up critical DynamoDB metadata using point-in-time recovery or scheduled export once production data exists.
- Store Terraform state in a dedicated protected backend with versioning and locking.
- Keep deployment infrastructure reproducible from source control.

## Restore priorities

1. Identity and access configuration.
2. Metadata database.
3. Original archival audio.
4. Artwork.
5. Derived streaming copies, which may be regenerated.
6. Frontend assets, which may be rebuilt from source.

## Deep archive

Glacier-class storage may be used for secondary archival copies later, but active playback objects should remain in a class appropriate for direct CloudFront delivery.
