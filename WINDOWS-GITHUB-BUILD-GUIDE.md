# FaceFlow — Windows → GitHub → Temporary macOS Build Guide

This project is prepared so you can build the iOS app without owning a Mac.

## What this setup does

Your Windows PC:
  1. You upload this project to GitHub.
  2. GitHub Actions starts a fresh macOS machine.
  3. Xcode on that machine builds FaceFlow.
  4. GitHub gives you a downloadable build artifact.

The workflow is configured for a **public GitHub repository**, because standard
macOS runners are free and unlimited for public repositories.

## Important limitation

This workflow builds an **unsigned iOS Simulator app**. It is useful for proving
that the Swift/Xcode project compiles.

It does NOT create an installable App Store/TestFlight IPA. Apple requires code
signing, an Apple Developer account, certificates/provisioning, and eventually
App Store Connect.

## STEP 1 — Create your GitHub repository

1. Go to https://github.com/
2. Sign in or create a GitHub account.
3. Click **New repository**.
4. Repository name: `FaceFlow`
5. Set it to **Public**.
6. Do NOT add a README, .gitignore, or license — this package already contains them.
7. Create the repository.

Why public? GitHub currently provides standard GitHub-hosted macOS runners free
and unlimited for public repositories.

## STEP 2 — Upload this project

On the new repository page:

1. Click **Add file** → **Upload files**.
2. Open the `FaceFlow-GitHub-Mac-Build` folder from this package.
3. Upload the CONTENTS of that folder, including:
   - `FaceFlow.xcodeproj`
   - `FaceFlow/`
   - `FaceFlowTests/`
   - `FaceFlowUITests/`
   - `.github/`
   - `.gitignore`
   - `README.md`
4. Commit the files to the `main` branch.

IMPORTANT:
The `.github/workflows/ios-build.yml` file must end up at exactly:

    .github/workflows/ios-build.yml

## STEP 3 — Start the Mac build

1. Open your repository on GitHub.
2. Click the **Actions** tab.
3. On the left, click **FaceFlow iOS Build**.
4. Click **Run workflow**.
5. Select `main`.
6. Click the green **Run workflow** button.

GitHub will now create a temporary macOS runner and run Xcode.

## STEP 4 — Download the result

When the workflow becomes green:

1. Open the completed workflow run.
2. Scroll to **Artifacts**.
3. Download `FaceFlow-iOS-Simulator`.
4. Extract the downloaded ZIP on Windows.

The artifact contains `FaceFlow-iOS-Simulator.zip`.

## If the build fails

Open the failed workflow run and click the **Build FaceFlow on macOS** job.
Expand the failed step and copy the error text.

Send that error to ChatGPT and I can modify the project/workflow to fix it.

## STEP 5 — Later: build for a real iPhone

The current workflow intentionally does not sign the app.

To install FaceFlow on a real iPhone or distribute it through TestFlight,
you will eventually need:

  - Apple ID
  - Apple Developer Program membership
  - A unique bundle identifier
  - App Store Connect app record
  - Apple signing certificates/profiles

At that stage, we can add GitHub Actions secrets for signing and create a
release/TestFlight workflow.

DO NOT put Apple certificates, private keys, or passwords directly into the
repository. They belong in GitHub Actions Secrets.

## Current FaceFlow bundle identifier

The MVP currently uses:

    com.example.FaceFlow

This is fine for the simulator build. Before App Store/TestFlight distribution,
change it to a unique identifier such as:

    com.yourname.faceflow

## StoreKit

The MVP includes local StoreKit testing and these product IDs:

    faceflow_pro_monthly
    faceflow_pro_yearly

Real subscriptions still need to be created/configured in App Store Connect.

## What you can do from Windows

You can continue editing the Swift files on Windows and push changes to GitHub.
Every push to `main` automatically starts the macOS build.

You therefore do NOT need a Mac just to iterate on the source code and verify
that the project compiles.

## Recommended workflow

    Windows
      ↓
    edit SwiftUI source
      ↓
    upload/commit to GitHub
      ↓
    GitHub Actions
      ↓
    temporary macOS + Xcode
      ↓
    build artifact
      ↓
    download artifact

## Cost

With a public repository using standard GitHub-hosted runners, GitHub currently
lists these macOS runners as free and unlimited. Keep the repository public if
your priority is avoiding GitHub Actions charges.

Do not use GitHub "larger" macOS runners for this project; those are paid.

