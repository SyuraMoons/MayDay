# Mayday Mobile App

Flutter client for the Mayday exercise readiness project. The current app covers:

- email/password sign up and login with Supabase Auth
- movement goal selection UI
- strength-plan concept UI
- profile setup storage in Supabase
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

No additional Supabase setup is required for basic testing in the current project. The app already points to a configured Supabase instance through [api_service.dart](./lib/api_service.dart).

## Run For Web

This is the fastest option for UI testing.

```bash
flutter run -d chrome
```

Useful when you only want to check:

- navigation flow
- login and registration UI
- goal selection screens
- strength-plan tab layout
- profile setup screens

Notes:

- Camera-based profile-photo features behave differently on web depending on the browser.
- Web is good for UI checks, but device photo flows should still be verified on Android or iOS.

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

- gallery photo selection for profile setup
- camera photo capture for profile setup
- Supabase-backed sign up, login, and profile setup save

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
- The project currently does not include the usual iOS camera/photo usage strings in [Info.plist](./ios/Runner/Info.plist).
- That means profile-photo flows may need additional iOS permission setup before full device testing.

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

This app currently uses the Supabase project values already defined in [api_service.dart](./lib/api_service.dart).

For most testers:

- you do not need to create your own Supabase project
- you can run the app immediately with the existing configuration
- sign up, login, profile setup save, and storage-backed image flows should work against the shared configured project

You only need your own Supabase project if:

- you want an isolated backend for your own testing
- the shared project becomes unavailable
- you want to modify the schema, storage rules, or auth configuration

The mobile app expects these Supabase resources to exist:

- `profiles` table
- `body_records` table
- `profile-photos` storage bucket

If you are setting up a fresh project, apply the SQL migrations in the repository under [`supabase/migrations`](../supabase/migrations).

## Current Scope

Implemented now:

- authentication
- movement goal selection UI
- strength-plan concept UI
- profile setup persistence and photo upload

Not implemented yet:

- real AI movement analysis
- physics simulation and reinforcement learning pipeline
- exercise prerequisite recommendation output
- movement capture as a primary workflow

## Troubleshooting

`flutter pub get` fails:

- run `flutter doctor`
- confirm your Flutter SDK is installed correctly

Supabase login or save fails:

- verify that the Supabase project is reachable
- verify the schema and storage bucket exist
- verify row-level security policies were applied

Camera or gallery actions fail on iOS:

- add the required iOS permission descriptions to [Info.plist](./ios/Runner/Info.plist)
- retest on simulator or device
