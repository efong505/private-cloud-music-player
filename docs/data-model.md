# Data Model

DynamoDB stores application metadata. S3 object keys are references, not the database of record.

## Core entities

- `ARTIST`
- `ALBUM`
- `TRACK`
- `PLAYLIST`
- `PLAYLIST_TRACK`
- `FAVORITE`
- `PLAY_HISTORY`
- `LIBRARY_STATS`

## Track example

```json
{
  "PK": "TRACK#01JXYZ",
  "SK": "METADATA",
  "trackId": "01JXYZ",
  "title": "Example Track",
  "artistId": "ARTIST#01ABC",
  "artist": "Example Artist",
  "albumId": "ALBUM#01DEF",
  "album": "Example Album",
  "trackNumber": 1,
  "discNumber": 1,
  "year": 2026,
  "genre": ["Rock"],
  "durationSeconds": 240.0,
  "codec": "FLAC",
  "sampleRate": 44100,
  "bitDepth": 16,
  "s3Key": "originals/example-artist/example-album/01-example-track.flac",
  "artworkKey": "artwork/example-album/cover-600.webp",
  "sha256": "...",
  "createdAt": "...",
  "updatedAt": "..."
}
```

## Search fields

Initial search avoids OpenSearch. Store normalized forms such as `titleNormalized`, `artistNormalized`, and `albumNormalized`, plus genre and year attributes. Dedicated search infrastructure may be added only when collection size or fuzzy-search requirements justify it.

## Integrity metadata

Every media object should retain expected SHA-256, byte size, codec, sample rate, bit depth, and channel count so the archive can be validated independently of S3 object naming.
