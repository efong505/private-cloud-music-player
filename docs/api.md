# API Surface

All protected routes require a valid Cognito JWT.

| Method | Route | Purpose |
|---|---|---|
| GET | `/me` | Current account |
| GET | `/artists` | List artists |
| GET | `/artists/{id}` | Artist detail |
| GET | `/albums` | List albums |
| GET | `/albums/{id}` | Album detail |
| GET | `/tracks` | List/search tracks |
| GET | `/tracks/{id}` | Track metadata |
| POST | `/tracks/{id}/play` | Return short-lived CloudFront signed playback URL |
| GET | `/playlists` | List playlists |
| POST | `/playlists` | Create playlist |
| PUT | `/playlists/{id}` | Update playlist |
| DELETE | `/playlists/{id}` | Delete playlist |
| POST | `/favorites/{id}` | Add favorite |
| DELETE | `/favorites/{id}` | Remove favorite |
| POST | `/history` | Record playback |
| GET | `/recent` | Recently played |
| GET | `/search?q=` | Library search |
| POST | `/admin/import` | Register an ingestion manifest |

## Playback contract

Example response from `POST /tracks/{id}/play`:

```json
{
  "url": "https://media.example.com/media/...signed-query...",
  "expiresAt": "2026-09-12T23:00:00Z"
}
```

The backend verifies that the authenticated user may access the track, then signs only the required CloudFront resource. The browser never receives AWS credentials or direct S3 access.

## Error handling

Use structured JSON errors with stable machine-readable codes. Authentication failures should not reveal whether an underlying media object exists.
