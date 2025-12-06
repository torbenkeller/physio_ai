# Backend

## Technology Stack

- Framework: Spring Boot
- Language: Kotlin
- Persistence: Spring Data JDBC
- Database Migrations: Flyway
- Testing: Mockk for mocking, WebMvcTest for Controller tests

## Architecture: Hexagonal (Ports and Adapters)

The project follows a hexagonal architecture with clear separation of concerns, enhanced by jMolecules
annotations:
- Domain: Core business entities marked with @AggregateRoot (e.g., PatientAggregate)
- Ports: Interfaces defining interactions with external systems.
  - Inbound Ports annotated with @PrimaryPort (service interfaces)
  - Outbound Ports: annotated with @SecondaryPort (repository interfaces)
- Adapters: Implementations connecting to external systems
  - Inbound Adapters: annotated with @PrimaryAdapter (controller implementations)
  - Outbound Adapters: annotated with @SecondaryAdapter (repository implementations)
- Application: Service implementations orchestrating domain operations, annotated with @Application

These jMolecules annotations explicitly document the architectural role of each component, enhancing code clarity and enabling static architecture validation. The architecture follows a strict dependency rule where the domain core has no dependencies on infrastructure concerns.

## Best Practices:

- Use constructor injection over property injection
- Use immutable data classes for domain models
- Follow the ktlint code style
- Use necessary test configuration for each test

### Error Handling:

- Throw AggregateNotFoundException() when the repository doesn't find an aggregate
- Throw AccessDeniedException() when a user has no permission to access a resource

## Commands (run from backend/ directory):

- Run: ./mvnw spring-boot:run
- Build Backend: ./mvnw package
- Test: ./mvnw test
- Test single class: ./mvnw -Dtest=<TestClass> test
- Format: ./mvnw antrun:run@ktlint-format
- Lint: ./mvnw antrun:run@ktlint-lint
