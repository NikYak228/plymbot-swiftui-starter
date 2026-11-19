# Plymbot · SwiftUI starter

A minimal, public interface prototype for Plymbot, the native iOS companion to
Plyrum. This repository contains the initial Swift files and a standalone Xcode
project. It is a small starting point for the open-source app.

## Try it

Requires macOS, Xcode 15 or later, and an iOS 17+ simulator.

1. Open `Plymbot.xcodeproj` in Xcode.
2. Select the **Plymbot** scheme and an iPhone simulator.
3. Press **Run**. No account, API key, signing team or dependencies are needed
   for the simulator.

For a physical iPhone, select your own development team in Signing & Capabilities.

## Included

- Native SwiftUI chat with an empty state, prompt suggestions and composer.
- Local message history, new-chat action and an explicitly labeled demo reply.
- Model/provider picker, including an illustrative Auto option.
- Settings screen and system light/dark appearance; no external assets.

This is a **UI prototype**. The replies are local canned text. Provider requests,
automatic routing, credential storage, account sync and streaming are not
implemented here. The catalog shows provider placeholders, not live model IDs.
There is no TestFlight build associated with this repository.

## First proposed PR

Add one provider connection behind a `ChatClient` protocol: load the model list,
store the user's key in the iOS Keychain, send a chat request and show actionable
errors. Acceptance: a user selects a returned model and gets one real reply;
invalid-key and offline states are covered with stubbed transport tests.

## Validation

The source was prepared on Linux. Xcode compilation and simulator interaction
have not been performed in that environment. Run the Xcode project on a Mac
before treating it as a verified build.

## License

MIT. This repository contains only this standalone starter, not the production
Plyrum backend or the full private iOS application.
