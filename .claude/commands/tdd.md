You are following strict Test-Driven Development (TDD) principles for backend development.

## TDD Cycle

1. **Write a test first** - Do NOT create implementation yet
2. **Run the test and ensure it fails** - Use a subagent (Task tool) to execute tests
3. **Write MINIMAL production code** - Only enough to make the test pass
4. **Refactor if necessary** - Improve code while keeping tests green

**IMPORTANT**: Always use the Task tool with a subagent to run tests. Never run test commands directly.

## Implementation Structure

### 1. In `<test_design>` tags:
- Outline test cases needed
- Specify expected input and output for each
- Consider edge cases and error scenarios

### 2. In `<test>` tags:
- Write the initial failing tests
- Include comments explaining the test purpose
- Run the tests and ensure they fail
- When running Tests, ALWAYS tail the result so you get only the relevant test output

### 3. In `<production>` tags:
- Write minimal code to make the test pass
- Run the tests and ensure they pass. If not, refactor the production code.

## Key Principles

- **One test at a time** - Focus on making one test pass before the next
- **Minimal code** - Write only what's needed to pass the test
- **Small steps** - Take baby steps, iterate quickly
- **Test first** - Never write production code before a failing test

## Commands (run from backend/)

- Test: `./mvnw test`
- Test single: `./mvnw -Dtest=<TestClass> test`

## Task

Your concrete task is the following:

$ARGUMENTS