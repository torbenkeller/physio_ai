# Frontend (Flutter)

This file is only related to the frontend code. You MUST NOT respect this file when editing the backend code.

## Commands

### Build Commands

- Run app: `flutter run`
- Build app: `flutter build <platform>`
- Run the Build Runner: `dart run build_runner build --delete-conflicting-outputs`

### Lint Commands

- Lint code: `flutter analyze`
- Format code: `dart format <directory / files / . for all>`
- Fix lint issues: `dart fix --apply`
- Custom lint: `dart r8un custom_lint`

### Test Commands

- Run all tests: `flutter test`
- Run a specific test: `flutter test test/<path_to_test_file>.dart`

### Tools

- Use the `flutterInspector` tool to get debug details of the running flutter app
- Use the `pubdev` tool to get documentation details about packages

## Decisions

### Code Style

- Flutter: Follow the [very_good_analysis](https://pub.dev/packages/very_good_analysis) style guide
- Max line length is 120 (default 80-char limit is disabled)
- Use dart's strong typing features throughout the codebase
- Do NOT modify files inside `**/generated/**` folders
- Always add trailing commas
- Always use the latest language features
- Always use the text styles and colors from the App Theme

### Packages

- Use freezed for immutable models and json_serializable for DTOs
- Use flutter_riverpod for state management
- Use go_router for navigation
- Use retrofit for repositories
- Use IList from fast_immutable_collections instead of List
- Use flutter_intl for Localizations with German as main locale

### Rules

- Error handling should use proper Exception types and logging
- Use only dart-doc comments when commenting code
- Use immutable data classes for state management
- Use Repositories to access API's
- Create new widgets when the build method gets too long
- You MUST always format the code before finishing a task

### Testing the Frontend

- There are no unit tests of Repositories because their functionality is highly dependent on the backend responses
- End-to-End Tests MUST test the important user journeys of the product
- Unit Test the all `FormContainer` implementations
