# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands
- Run app: `flutter run`
- Build app: `flutter build <platform>`
- Generate code: `flutter pub run build_runner build --delete-conflicting-outputs`
- Watch generated code: `flutter pub run build_runner watch --delete-conflicting-outputs`

## Lint Commands
- Lint code: `flutter analyze`
- Fix lint issues: `dart fix --apply`
- Custom lint: `dart run custom_lint`

## Test Commands
- Run all tests: `flutter test`
- Run a specific test: `flutter test test/<path_to_test_file>.dart`

## Code Style Guidelines
- Follow the [very_good_analysis](https://pub.dev/packages/very_good_analysis) style guide
- Max line length is unlimited (default 80-char limit is disabled)
- Imports should be organized in groups: dart, flutter, packages, project imports
- Use freezed for immutable models and json_serializable for DTOs
- Use Riverpod for state management
- Use go_router for navigation
- Error handling should use proper Exception types and logging
- Internationalization using flutter_intl with German as main locale
- Repository pattern for data access with retrofit for API calls
- Use dart's strong typing and null safety features throughout the codebase