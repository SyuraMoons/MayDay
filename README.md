# Mayday

Mayday is a movement-readiness app concept focused on one core question:

"To perform a target movement without injury, or to perform it better, which parts of my body do I need to strengthen and by how much?"

The longer-term idea is:

- collect user body data
- collect skeletal reference photos during profile setup
- use physics simulation and reinforcement learning to estimate movement demands
- translate those demands into understandable training benchmarks

At the current stage, the main implemented work is the Flutter mobile app UI and its Supabase integration.

## Repository Structure

### [`Mobapp/`](/Users/harfi/Documents/Project/Capstone-jbnu/maydayy/Mobapp)

Flutter client application.

This is the main part to run right now. It currently includes:

- sign up and login with Supabase Auth
- movement goal selection UI
- strength-plan concept UI
- profile setup with body data and one skeletal reference photo
- Supabase-backed body data and image storage flow

Start here if you want to test the project.

Detailed setup and run instructions are in [Mobapp/README.md](/Users/harfi/Documents/Project/Capstone-jbnu/maydayy/Mobapp/README.md).

### [`supabase/`](/Users/harfi/Documents/Project/Capstone-jbnu/maydayy/supabase)

Supabase SQL migrations and schema setup.

This folder contains the database structure used by the app, including:

- `profiles` table
- `body_records` table
- storage bucket setup
- row-level security policies

Most people testing the current app do not need to touch this folder, because the mobile app is already configured to use an existing Supabase project.

## What Is Already Implemented

- Flutter mobile app
- Supabase authentication
- Supabase database integration for profile setup
- Supabase storage integration for images
- movement goal selection UI
- strength-plan UI structure
- profile setup UI

## What Is Not Implemented Yet

- real AI movement analysis
- physics simulation pipeline
- exercise prerequisite recommendation output
- movement capture as a primary workflow

## How To Run

For most people, go directly to:

```bash
cd Mobapp
flutter pub get
flutter run -d chrome
```

You can also test on Android or iOS. Full instructions are in [Mobapp/README.md](/Users/harfi/Documents/Project/Capstone-jbnu/maydayy/Mobapp/README.md).

## Supabase Note

Supabase is already configured in the mobile app for basic testing, so you do not need to create your own Supabase project just to run the current build.

You would only need your own Supabase setup if:

- you want an isolated environment
- the existing configured project is unavailable
- you want to change schema or auth settings
