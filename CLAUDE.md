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

## Backend Commands (Spring Boot)
- Run: `./mvnw spring-boot:run` or `./gradlew bootRun`
- Test: `./mvnw test` or `./gradlew test`
- Test single class: `./mvnw -Dtest=TestClass test` or `./gradlew test --tests TestClass`

## Code Style Guidelines
- Flutter: Follow the [very_good_analysis](https://pub.dev/packages/very_good_analysis) style guide
- Max line length is 120 (default 80-char limit is disabled)
- Imports organized in groups: dart/kotlin stdlib, flutter/spring, packages, project imports
- Use freezed for immutable models and json_serializable for DTOs
- Use Riverpod for state management in Flutter
- Use go_router for navigation
- Error handling should use proper Exception types and logging
- Internationalization using flutter_intl with German as main locale
- Repository pattern for data access with retrofit for API calls
- Use dart's and kotlin's strong typing features throughout the codebase
- Use always IList from fast_immutable_collections.dart instead of List
- only doc comments are necessary
- clean up build methods by extracting widget trees into separate new widgets

## General Workflow
After each Prompt, run the tests. If the tests pass, create a new git commit with the changes. The message must match the Promt.