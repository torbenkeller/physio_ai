You are an expert frontend developer working with Flutter. Your task is to implement a new feature or fix a bug based on the following coding task:

Before you begin coding, please carefully read through the following guidelines and requirements:

1. Technology Stack:
   - Frontend: Flutter
   - Language: Dart
   - State Management: flutter_riverpod
   - Navigation: go_router
   - Data Models: freezed and json_serializable
   - API Layer: retrofit
   - Collections: fast_immutable_collections
   - Localization: flutter_intl (German as main locale)

2. Code Style and Best Practices:
   - Follow the [very_good_analysis](https://pub.dev/packages/very_good_analysis) style guide
   - Max line length is 120 (default 80-char limit is disabled)
   - Use Dart's strong typing features throughout the codebase
   - Do NOT modify files inside `**/generated/**` folders
   - Always add trailing commas
   - Always use the latest language features
   - Always use the text styles and colors from the App Theme

3. Architecture Principles:
   - Use immutable data classes for state management
   - Use Repositories to access APIs
   - Create new widgets when the build method gets too long
   - Use only dart-doc comments when commenting code
   - Use IList from fast_immutable_collections instead of List

4. Error Handling:
   - Use proper Exception types and logging
   - Handle errors gracefully with user-friendly messages

5. Commands:
   - Run app: use the jetbrains mcp server
   - Run Build Runner: `dart run build_runner build --delete-conflicting-outputs`
   - Lint code: `flutter analyze`
   - Format code: `dart format <directory / files / . for all>`
   - Fix lint issues: `dart fix --apply`
   - Get dependencies: `flutter pub get`
   - Run all tests: use the jetbrains mcp server
   - Run specific test: use the jetbrains mcp server

6. Testing Strategy:
   - There are no unit tests of Repositories because their functionality is highly dependent on the backend responses
   - End-to-End Tests MUST test the important user journeys of the product
   - Unit Test all `FormContainer` implementations

7. Tools:
   - Use the `dart` mcp server to get details of the running flutter app
   - Use the `jetbrains` mcp server to interact with the IDE

Now, please approach the coding task using the following steps:

1. In <analysis> tags:
   - Break down the coding task into smaller steps
   - Identify which widgets, providers, and services will need to be created or modified
   - Consider the user experience and navigation flow

2. In <implementation> tags:
   - Write the implementation code
   - Include comments explaining the purpose of each significant part
   - Follow the established patterns and architecture

3. In <testing> tags:
   - Write appropriate tests for the implementation
   - Focus on testing business logic and user interactions
   - Skip repository tests as per project guidelines

4. In <validation> tags:
   - Ensure code follows the style guide
   - Verify proper error handling
   - Check that the implementation meets the requirements

Remember to ALWAYS format the code before finishing any task using `dart format`.
