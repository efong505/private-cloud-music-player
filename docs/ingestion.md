# Ingestion Pipeline

CD ripping occurs locally. The cloud pipeline receives already-created audio files and metadata; it does not circumvent copy protection.

## Preferred archival format

For standard audio CDs, preserve a FLAC master at 44.1 kHz / 16-bit. Derived streaming formats may be added later without modifying the archival master.

## Local flow

```text
Physical CD
  -> local accurate rip
  -> FLAC
  -> metadata extraction
  -> SHA-256
  -> manifest generation
  -> upload to ingestion S3
```

## Cloud flow

```text
UPLOAD
  -> VALIDATE
  -> HASH / metadata verification
  -> ARTWORK normalization
  -> optional TRANSCODE
  -> INDEX in DynamoDB
  -> READY
```

Import state values:

- `UPLOADING`
- `VALIDATING`
- `PROCESSING`
- `READY`
- `FAILED`

The workflow must be idempotent so retries never create duplicate tracks.

## Compute selection

Lambda is appropriate for lightweight metadata, validation, indexing, and orchestration. Heavy FFmpeg transcoding should move to an on-demand ECS/Fargate task if runtime or CPU requirements outgrow Lambda.

## Local command target

The intended Windows workflow is:

```powershell
.\Import-Album.ps1 -Path "D:\Music\Rips\Artist\Album"
```

The script will eventually validate files, generate a manifest, calculate checksums, upload staged content, and invoke or signal backend ingestion.
