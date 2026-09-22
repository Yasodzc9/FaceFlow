# FaceFlow iOS MVP

FaceFlow is a SwiftUI iOS MVP for short guided face & neck self-care routines.

## Included
- Onboarding with goals, duration, experience and reminder preference
- Home dashboard
- 20 exercise library entries
- Guided routine player with timers, progress, pause/skip, and spoken guidance
- Daily streak and progress history
- Explore tab
- Profile/settings
- Local notification reminders
- StoreKit 2 subscription manager with monthly/yearly product IDs
- A deterministic local routine generator for the MVP (safe: it selects only from the bundled exercise library)
- StoreKit local testing configuration

## Requirements
- Xcode 16+
- iOS 17+
- Swift 5.9+

## Open
Open `FaceFlow.xcodeproj` in Xcode and run on an iOS Simulator or device.

For real App Store subscriptions, create these products in App Store Connect:
- `faceflow_pro_monthly`
- `faceflow_pro_yearly`

The app will still run without products; the paywall will show the configured product IDs as unavailable until StoreKit products are configured.

## Privacy
The MVP does not use the camera and does not send health/face data anywhere. The future AI Form Coach is intentionally not included in this first build.

## Architecture
SwiftUI + Observation/Combine-compatible Foundation APIs + StoreKit 2 + UserNotifications + AVFoundation.
No third-party dependencies.


## Build from Windows

See `WINDOWS-GITHUB-BUILD-GUIDE.md`. The included GitHub Actions workflow builds the app on a temporary GitHub-hosted macOS runner.
