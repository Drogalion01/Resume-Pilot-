# ResumePilot — Flutter App

The Flutter mobile client for ResumePilot. Targets Android (primary), with web and Windows scaffolds in place.

## Structure

```
lib/
├── main.dart
├── app/                   # Bootstrap: router, theme, app widget
├── core/                  # API client, constants, error handling, design tokens
│   ├── api/
│   ├── constants/         # api_constants.dart — base URL config
│   ├── errors/
│   └── theme/             # app_colors, app_spacing, app_typography, app_theme
├── features/              # Feature modules (each: models, providers, services, screens, widgets)
│   ├── auth/
│   ├── applications/
│   ├── resumes/
│   ├── interviews/
│   ├── reminders/
│   └── settings/
└── shared/                # Shared widgets and utilities used across features
    ├── widgets/
    └── providers/
```

## Running

```bash
# Install dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Run on a specific device
flutter run -d <device-id>

# Build release APK
flutter build apk --release
```

## API Connection

The base URL is configured in `lib/core/constants/api_constants.dart`.

| Environment | Default URL |
|---|---|
| Android emulator | `http://10.0.2.2:8000` |
| Physical device | Your machine's local IP, e.g. `http://192.168.x.x:8000` |
| Production | Set `baseUrl` to your deployed backend URL |

## Design System

Design tokens live in `lib/core/theme/`:

| File | Contents |
|---|---|
| `app_colors.dart` | Brand palette, semantic color aliases |
| `app_spacing.dart` | 4 px base grid spacing + radius tokens |
| `app_typography.dart` | Text styles — display through label |
| `app_theme.dart` | `ThemeData` (light + dark) wiring all tokens |
