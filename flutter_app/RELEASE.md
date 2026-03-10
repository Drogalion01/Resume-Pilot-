# ResumePilot Flutter App — Release Guide

## Architecture Summary

- **Framework:** Flutter 3.41.4 · Dart SDK ≥3.3.0
- **State management:** Riverpod (flutter_riverpod)
- **Navigation:** go_router
- **HTTP:** Dio with interceptors (auth, refresh, error)
- **Auth storage:** flutter_secure_storage
- **API base URL:** compile-time via `--dart-define=API_BASE_URL=<url>`
- **Platform:** Android (primary), Web (secondary), Windows (dev)

---

## 1. Prerequisites

```bash
flutter --version   # Must be ≥3.41.4
dart --version      # Must be ≥3.3.0
flutter doctor      # All green (at minimum Android toolchain)
```

---

## 2. Install Dependencies

```bash
cd flutter_app
flutter pub get
```

---

## 3. Keystore Setup (Release Signing)

### 3a. Generate a keystore (one-time)
```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -alias upload
```

**Store the `.jks` file somewhere safe — it is not recoverable if lost.**  
The `.jks` file must NEVER be committed to git (already in `.gitignore`).

### 3b. Create `flutter_app/android/key.properties`
```properties
storePassword=<your-keystore-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<absolute/path/to/upload-keystore.jks>
```

See `flutter_app/android/key.properties.example` for the template.

---

## 4. Configure the API Base URL

The API URL is injected at compile time. Set it to your deployed backend URL.

```bash
--dart-define=API_BASE_URL=https://your-backend.railway.app/api/v1
```

Default fallback (Android emulator pointing to localhost):
```
http://10.0.2.2:8000/api/v1
```

---

## 5. Build Android Release APK

```bash
cd flutter_app
flutter build apk --release \
  --dart-define=API_BASE_URL=https://your-backend.railway.app/api/v1
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (required for Play Store)
```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://your-backend.railway.app/api/v1
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## 6. Build & Run Debug (Android Emulator)

```bash
cd flutter_app
flutter run --debug \
  --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

Or use the VS Code launch configurations in `.vscode/launch.json`.

---

## 7. VS Code Launch Configurations

Pre-configured in `.vscode/launch.json`:

| Config | Platform | API URL |
|---|---|---|
| Flutter (Android Emulator) | Android emulator | `http://10.0.2.2:8000/api/v1` |
| Flutter (Windows) | Windows desktop | `http://localhost:8000/api/v1` |
| Flutter (Web – Chrome) | Chrome | `http://localhost:8000/api/v1` |
| Flutter (Staging – Physical Device) | Physical device | `https://api-staging.resumepilot.app/api/v1` |
| Flutter (Production – Physical Device) | Physical device | `https://api.resumepilot.app/api/v1` |

**Update the staging/production URLs** in `.vscode/launch.json` after you deploy the backend.

---

## 8. App Configuration

| Setting | Value |
|---|---|
| App name | ResumePilot |
| Package name | `com.resumepilot.app` |
| Version | `1.0.0+1` |
| Min SDK | 21 (Android 5.0) |
| Target SDK | 35 |
| Permissions | `INTERNET` |

---

## 9. Play Store Submission Steps

1. Build `.aab` with release signing (§5)
2. Create app in [Google Play Console](https://play.google.com/console)
3. Package name: `com.resumepilot.app`
4. Upload `.aab` to Internal Testing track first
5. Fill in store listing: title, description, screenshots, icon
6. Set content rating
7. Promote through tracks: Internal → Closed Testing → Open Testing → Production

---

## 10. App Icons

Default Flutter launcher icon is currently in use. To replace with custom branding:

1. Place a 1024×1024 PNG at `assets/icons/app_icon.png`
2. Add [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) to `pubspec.yaml` dev\_dependencies
3. Configure in `pubspec.yaml`:
   ```yaml
   flutter_launcher_icons:
     android: true
     ios: true
     image_path: "assets/icons/app_icon.png"
   ```
4. Run: `dart run flutter_launcher_icons`

---

## 11. Post-Build Verification

After building release APK:
```bash
# Install on connected device
flutter install --release

# Check app launches, login works, and resume upload works end-to-end
```

---

## 12. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Network calls fail in release build | Missing INTERNET permission | Already fixed — `AndroidManifest.xml` has `INTERNET` permission |
| `Signing config error` | `key.properties` missing | Create it from `key.properties.example` |
| API calls hit wrong URL | `API_BASE_URL` not set | Pass `--dart-define=API_BASE_URL=...` |
| `401 Unauthorized` after deploy | Token expired or wrong `SECRET_KEY` | Re-login; verify `SECRET_KEY` matches between old and new deploys |
| App crashes on startup | Missing required provider | Run `flutter run --debug` to see stack trace |
