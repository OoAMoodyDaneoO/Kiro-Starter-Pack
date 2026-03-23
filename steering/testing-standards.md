# Testing Standards

<!-- Scope: Global -->
<!-- Description: Enforce comprehensive, reliable test coverage with consistent organization, naming, structure, and property-based testing -->

## Overview

These standards define the testing rules that Kiro enforces during test generation and review. All rules are language-agnostic and apply regardless of the testing framework or programming language in use. The goal is to ensure every project has well-organized, readable, and trustworthy tests.

## Rules

### Test File Organization

- **Co-location — Place tests next to source files**: Test files should live alongside the source files they test in the same directory. A module `user-service.ts` should have a sibling `user-service.test.ts`. This makes it easy to find tests and keeps related code together.
- **Dedicated directory — Use when co-location is impractical**: When project conventions or tooling require a separate test directory, mirror the source directory structure under a top-level `tests/` or `__tests__/` folder. The path to a test file should match the path to the source file it covers.
- **One test file per module — Keep test scope focused**: Each test file should cover exactly one source module, class, or logical unit. Do not combine tests for unrelated modules into a single file. This keeps test files small and failures easy to locate.
- **Test file naming — Match source file with test suffix**: Test files must use the same base name as the source file with a `.test` or `.spec` suffix before the extension (e.g., `parser.test.ts`, `parser_test.py`). Follow the project's established convention consistently.

### Test Naming Conventions

- **Describe the scenario — Use plain-language test names**: Test names must describe the scenario under test in plain language. Prefer `should return empty array when no items match filter` over `test1` or `testFilter`. The name should read as a sentence that explains what is being verified.
- **Include input and expected outcome — State cause and effect**: Each test name should convey what input or condition is given and what outcome is expected. Example: `rejects negative quantities` or `returns cached result when called twice with same key`.
- **Group related tests — Use describe or context blocks**: Group related tests under a `describe`, `context`, or equivalent block named after the unit under test. Nest sub-groups for different behaviors or states: `describe('UserService')` → `describe('createUser')` → `it('throws when email is missing')`.
- **Avoid implementation details in names — Focus on behavior**: Test names must describe observable behavior, not internal implementation. Prefer `calculates total with tax` over `calls calculateTax helper`. Tests named after behavior survive refactors.

### Test Structure

- **Arrange-Act-Assert — Follow the AAA pattern**: Every test must follow the Arrange-Act-Assert structure. First set up the preconditions (Arrange), then execute the action under test (Act), then verify the result (Assert). Separate each phase with a blank line for readability.
- **Single assertion focus — Test one behavior per test**: Each test should verify one logical behavior. Multiple assertions are acceptable when they all verify aspects of the same outcome (e.g., checking both status code and response body). Do not test unrelated behaviors in a single test.
- **No test interdependence — Tests must run in isolation**: Tests must not depend on the execution order or side effects of other tests. Each test must set up its own state and clean up after itself. Shared mutable state between tests is a bug.
- **Minimal setup — Keep arrange sections lean**: Only set up what is necessary for the specific test. Avoid large shared fixtures that configure data irrelevant to the test at hand. Extract common setup into helper functions or `beforeEach` blocks only when it reduces duplication without hiding important context.

### Mocking and Stubbing

- **Minimal test doubles — Mock only external boundaries**: Only mock or stub external dependencies that are slow, non-deterministic, or have side effects (network calls, databases, file systems, clocks). Do not mock internal modules or pure functions — test them with real implementations.
- **Prefer fakes over mocks — Use simple in-memory implementations**: When a test double is needed, prefer a lightweight fake (e.g., an in-memory repository) over a mock with assertion-heavy verification. Fakes test behavior; mocks test implementation details.
- **Verify interactions sparingly — Assert on outcomes, not calls**: Avoid asserting on the number of times a dependency was called or the exact arguments passed unless the interaction itself is the behavior under test (e.g., verifying an event was published). Prefer asserting on the final result.
- **Reset state between tests — Clean up mocks and stubs**: All mocks, stubs, and spies must be reset or restored between tests. Use `afterEach` or equivalent teardown hooks to prevent leaked state from causing flaky tests.

### Property-Based Testing

- **Universal properties — Validate invariants across all inputs**: Identify properties that must hold true for every valid input and express them as property-based tests. Examples: a sort function always returns a list of the same length, encoding then decoding returns the original value, serialization is reversible.
- **Use a PBT library — Leverage framework support**: Use a property-based testing library appropriate for the project's language and test framework (e.g., fast-check for JavaScript/TypeScript, Hypothesis for Python, QuickCheck for Haskell, jqwik for Java). Do not hand-roll random input generation.
- **Constrain generators — Generate valid inputs intelligently**: Write custom generators or use library combinators to produce inputs that satisfy the function's preconditions. Generating arbitrary data that immediately fails validation wastes test cycles and obscures real failures.
- **Shrink to minimal examples — Let the library minimize failures**: When a property test fails, rely on the library's shrinking mechanism to find the smallest failing input. Report the shrunk example in test output so developers can reproduce and debug efficiently.
- **Complement example tests — Use PBT alongside unit tests**: Property-based tests do not replace example-based unit tests. Use both: unit tests for specific known scenarios and edge cases, property tests for broad invariant validation across the input space.
