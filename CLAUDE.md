# Frontend (Flutter)

## Frontend (Flutter) -> Commands

### Frontend (Flutter) -> Commands -> Build Commands
- Run app: `flutter run`
- Build app: `flutter build <platform>`
- Run the Build Runner: `flutter pub run build_runner build --delete-conflicting-outputs`

### Frontend (Flutter) -> Commands -> Lint Commands
- Lint code: `flutter analyze`
- Fix lint issues: `dart fix --apply`
- Custom lint: `dart run custom_lint`

### Frontend (Flutter) -> Commands -> Test Commands
- Run all tests: `flutter test`
- Run a specific test: `flutter test test/<path_to_test_file>.dart`

## Frontend (Flutter) -> Decisions

### Frontend (Flutter) -> Decisions -> Code Style
- Flutter: Follow the [very_good_analysis](https://pub.dev/packages/very_good_analysis) style guide
- Max line length is 120 (default 80-char limit is disabled)
- Use dart's strong typing features throughout the codebase
- Do NOT modify files inside `**/generated/**` folders

### Frontend (Flutter) -> Decisions -> Packages
- Use freezed for immutable models and json_serializable for DTOs
- Use flutter_riverpod for state management in Flutter
- Use go_router for navigation
- Use retrofit for repositories
- Use IList from fast_immutable_collections instead of List
- Use flutter_intl for Localizations with German as main locale

### Frontend (Flutter) -> Decisions -> Guidelines
- Error handling should use proper Exception types and logging
- Use only dart-doc comments when commenting code
- Use immutable data classes for state management
- Use Repositories to access API's
- Create new widgets when the build method gets too long

### Frontend (Flutter) -> Decisions -> Testing the Frontend
- There are no unit tests of Repositories because their functionality is highly dependent on the backend responses
- End-to-End Tests MUST test the important user journeys of the product
- Unit Test the all `FormContainer` implementations

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

# General

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
- Tests MUST cover the functionality being implemented
