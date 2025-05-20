# Backend  (Spring Boot)

This file is only related to the backend code. You MUST NOT respect this file when editing the frontend code.

## Commands

### Build Commands

- Run: `./mvnw spring-boot:run`
- Build Backend: `./mvnw package`

### Test Commands

- Test: `./mvnw test`
- Test single class: `./mvnw -Dtest=<TestClass> test`

### Lint Commands

- Format: `./mvnw antrun:run@ktlint-format`
- Lint: `./mvnw antrun:run@ktlint-lint`

## Decisions

### Code Style

- use constructor injection over property injection
- use the necessary test configuration for each test
- use immutable data classes for domain models
- follow the ktlint code style
- throw the AggregateNotFoundException() when the repository does not find an aggregate
- throw the AccessDeniedException() when a user has no permission to access a resource
- use WebMvcTest for testing Controllers

### Packages

- use Mockk for mocking in tests
- use Spring Data JDBC for persistence
- use flyway for database migrations

# Workflow

**We practice TDD. That means**

You MUST structure your TODOs as follows:

1. Write a test. DO NOT create the implementation of the production code yet
2. Run the test and make sure it fails
3. Write MINIMAL production code to make the test pass