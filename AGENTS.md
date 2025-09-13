# Repository Guidelines

## Goal
- Design a login mechanism with Multi-Factor Authentication (MFA)
- The first factor is the user’s account and password.
- The second factor is biometric authentication (Fingerprint or Face Recognition).

This system simulates enterprise internal application login requirements, aiming to balance both security and user experience.

## Project Structure & Module Organization
- `lib/` — Dart source (UI, state, services). Create feature folders, e.g. `lib/feature/login/`.
- `test/` — Unit/widget tests mirroring `lib/` paths (e.g., `test/feature/login/`).
- `android/`, `ios/` — Native build targets; avoid manual edits unless platform‑specific work.
- `assets/` (optional) — Add images/fonts and register in `pubspec.yaml` under `flutter.assets`.

## Build, Test, and Development Commands
- Install deps: `flutter pub get`
- Analyze lints: `flutter analyze`
- Format code: `dart format .` (add `--fix` to apply safe fixes)
- Run app (debug): `flutter run`
- Run tests: `flutter test`
- Coverage (lcov): `flutter test --coverage` → report at `coverage/lcov.info`
- Build release (Android): `flutter build apk`
- Build release (iOS, macOS only): `flutter build ios`

## Coding Style & Naming Conventions
- Lints: configured via `analysis_options.yaml` (includes `flutter_lints`). Fix all warnings before PR.
- Indentation/format: use `dart format` (2‑space indent). No trailing whitespace.
- Naming: classes `PascalCase`; methods/vars `lowerCamelCase`; files `snake_case.dart`.
- Structure: prefer small widgets/services; keep platform code isolated under `platform/` subfolders if needed.

## Testing Guidelines
- Framework: `flutter_test` with unit and widget tests (`testWidgets`).
- Location: mirror `lib/` and name files `*_test.dart` (e.g., `button_test.dart`).
- Expectations: cover core logic and critical UI states; add golden tests for stable visuals when applicable.
- Run locally: `flutter test` (CI must pass). For flakes, mark clearly and deflake before merge.

## Commit & Pull Request Guidelines
- Commits: use Conventional Commits, e.g. `feat: add login form`, `fix: handle null token`, `test: add auth widget tests`.
- Scope small and focused; reference issues like `(#123)` in the subject or body.
- PRs: include summary, screenshots for UI changes, test plan (`commands run`, `results`), and link to related issues.
- CI: ensure `analyze`, `format`, and `test` pass before requesting review.

## Security & Configuration Tips
- Never commit secrets or API keys. Pass runtime config via `--dart-define=KEY=VALUE` and read with `const String.fromEnvironment`.
- Review third‑party packages in `pubspec.yaml`; prefer well‑maintained, null‑safe packages.
