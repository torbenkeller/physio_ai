# Frontend (Flutter)

## Build Commands
- Run app: `flutter run`
- Build app: `flutter build <platform>`
- Run the Build Runner: `flutter pub run build_runner build --delete-conflicting-outputs`

## Lint Commands
- Lint code: `flutter analyze`
- Fix lint issues: `dart fix --apply`
- Custom lint: `dart run custom_lint`

## Test Commands
- Run all tests: `flutter test`
- Run a specific test: `flutter test test/<path_to_test_file>.dart`

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
- Use dart's strong typing features throughout the codebase
- Use always IList from fast_immutable_collections.dart instead of List
- only doc comments are necessary
- clean up build methods by extracting widget trees into separate new widgets

# Backend  (Spring Boot)

## Build Commands

- Run: `./mvnw spring-boot:run`
- Build Backend: `./mvnw package`

## Test Commands

- Test: `./mvnw test`
- Test single class: `./mvnw -Dtest=<TestClass> test`

## Code Style Guidelines

- Do use constructor injection over property injection
- Use the Mockk package for mocking in tests
- Do use ONLY the necessary test configuration for each test
- Use Spring Data JDBC with Kotlins immutable data classes for Persistence
- Follow the "Clean Code" paradigm

## General Workflow

**We practice TDD. That means**

- Write tests before writing the implementation code
- Only write enough code to make the failing test pass
- Refactor code continuously while ensuring tests still pass
- Write a failing test that defines a desired function or improvement
- Run only the created test to confirm it fails as expected
- Write minimal code to make the test pass
- Run the test to confirm success
- Refactor code to improve design while keeping tests green
- Repeat the cycle for each new feature or bugfix
- Tests MUST cover the functionality being implemented.
