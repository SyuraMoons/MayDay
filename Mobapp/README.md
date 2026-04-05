# Mayday Mobile App

Flutter client for the Mayday exercise readiness project. The current app covers:

- email/password sign up and login with Supabase Auth
- body setup storage in Supabase
- AI analysis entry UI for movement capture
- local testing on web, Android, and iOS

## Tech Stack

- Flutter
- Supabase Auth, Database, and Storage
- `image_picker` for photo/video selection and camera capture

## Prerequisites

Install these before running the app:

- Flutter SDK 3.11.x or newer
- Dart SDK matching the Flutter version
- Git
- Internet access for Supabase authentication, database, and storage requests
- Access to the configured Supabase project, or your own Supabase project with the same schema
- Chrome for web testing
- Android Studio or an Android device/emulator for Android testing
- Xcode and an iPhone Simulator or iPhone for iOS testing

Platform-specific prerequisites:

- Web:
  - Chrome installed
- Android:
  - Android Studio installed
  - Android SDK installed
  - an Android emulator or a physical Android device with USB debugging enabled
- iOS:
  - macOS
  - Xcode installed
  - CocoaPods available
  - an iPhone Simulator or physical iPhone

Check your Flutter setup:

```bash
flutter doctor
```

## Project Setup

1. Open the mobile app folder:

```bash
cd Mobapp
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app on your target platform.

## Run For Web

This is the fastest option for UI testing.

```bash
flutter run -d chrome
```

Useful when you only want to check:

- navigation flow
- login and registration UI
- body setup screens
- AI analysis tab layout

Notes:

- Camera-based features behave differently on web depending on the browser.
- Web is good for UI checks, but device capture flows should still be verified on Android or iOS.

## Run For Android

Start an emulator from Android Studio, or connect a physical Android device with USB debugging enabled.

Then run:

```bash
flutter run
```

If more than one device is connected:

```bash
flutter devices
flutter run -d <device-id>
```

Android is the best current option for testing:

- gallery photo selection
- gallery video selection
- live camera recording flow
- Supabase-backed sign up, login, and body setup save

## Run For iOS

Open the simulator from Xcode, or connect a physical iPhone, then run:

```bash
flutter run -d ios
```

If you want to choose a specific Apple device:

```bash
flutter devices
flutter run -d <device-id>
```

Important:

- iOS build tooling requires Xcode on macOS.
- The project currently does not include the usual iOS camera/photo usage strings in [Info.plist](/Users/harfi/Documents/Project/Capstone-jbnu/maydayy/Mobapp/ios/Runner/Info.plist).
- That means image and camera flows may need additional iOS permission setup before full device testing.

## Testing

Run static analysis:

```bash
flutter analyze
```

Run widget tests:

```bash
flutter test
```

Current automated coverage is minimal and mainly checks that the app opens on the login screen.

## Supabase Configuration

This app currently uses the Supabase project values already defined in [api_service.dart](/Users/harfi/Documents/Project/Capstone-jbnu/maydayy/Mobapp/lib/api_service.dart).

The mobile app expects these Supabase resources to exist:

- `profiles` table
- `body_records` table
- `profile-photos` storage bucket

If you are setting up a fresh project, apply the SQL migrations in the repository under [`supabase/migrations`](/Users/harfi/Documents/Project/Capstone-jbnu/maydayy/supabase/migrations).

## Current Scope

Implemented now:

- authentication
- profile/body setup persistence
- AI analysis tab UI
- movement capture entry points for photo, video, and live recording

Not implemented yet:

- real AI movement analysis
- exercise prerequisite recommendation output
- backend API usage from the `apii/` service

## Troubleshooting

`flutter pub get` fails:

- run `flutter doctor`
- confirm your Flutter SDK is installed correctly

Supabase login or save fails:

- verify that the Supabase project is reachable
- verify the schema and storage bucket exist
- verify row-level security policies were applied

Camera or gallery actions fail on iOS:

- add the required iOS permission descriptions to [Info.plist](/Users/harfi/Documents/Project/Capstone-jbnu/maydayy/Mobapp/ios/Runner/Info.plist)
- retest on simulator or device
