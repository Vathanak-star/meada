# meada_app

A new Flutter project.

## Gemini AI assistant

The AI assistant uses the Gemini REST API. For local development, provide the
key at runtime so it is not committed to the repository:

```bash
flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key --dart-define=GEMINI_MODEL=gemini-2.5-flash-lite
```

The app defaults to `gemini-2.5-flash-lite`. Set `GEMINI_MODEL` to another
model enabled for your API key when needed.

Create a key in Google AI Studio. Avoid shipping a production API key directly
in a client app; use a server-side proxy for a production release.

If an API key was previously placed directly in the source, revoke it in
Google AI Studio and create a replacement.

## Supabase chat history

Run [`supabase/chat_messages.sql`](supabase/chat_messages.sql) in the Supabase
SQL Editor. It creates the `chat_messages` table and row-level security rules.
The AI screen then loads and stores each signed-in user's messages securely.

Run [`supabase/health_tracking.sql`](supabase/health_tracking.sql) as well.
It creates the daily health and symptom tables with row-level security. Water
and mood are saved once per user per day; symptoms are saved as individual
dated records.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
