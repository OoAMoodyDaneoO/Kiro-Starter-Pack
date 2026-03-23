---
name: write-test-suite
description: "Generate a comprehensive test suite with unit tests, edge case tests, and property-based tests for an existing module. Use when adding test coverage."
---

## Description

Generates a comprehensive test suite for an existing source module. The skill reads the target module, identifies all exported functions, classes, and methods, then produces unit tests covering the happy path, edge case tests for boundary conditions and error paths, and property-based tests that validate invariants across a wide range of inputs. The generated tests follow the project's conventions for file naming, test structure, and assertion style.

When invoked, you'll need: the relative path to the source module to test (e.g., `src/services/user-service.ts`) and the testing framework (e.g., `jest`, `vitest`, `pytest`, `junit`, `go-test`). Optionally specify a PBT library (auto-detected from test framework), output path (default: co-located `<module>.test.<ext>`), and coverage focus (`all`, `unit-only`, `edge-cases-only`, `pbt-only`; default: `all`).

## Steps

1. **Analyze module** — Read and parse the target module to build a testing plan:
   - Identify all exported functions, classes, methods, and constants
   - Map each function's parameters, return types, and thrown exceptions
   - Detect logic branches (conditionals, loops, early returns) that need coverage
   - Identify external dependencies that may need mocking at the boundary
   - Note any pure functions suitable for property-based testing

2. **Generate unit tests** — Create tests for the happy-path behavior of each export:
   - Add a `describe` block for each exported function or class
   - Write tests that call each function with typical, valid inputs and assert the expected output
   - Follow the Arrange-Act-Assert pattern with clear separation between setup, execution, and verification
   - Use descriptive test names that state the input scenario and expected outcome — e.g., `should return user when given a valid ID`
   - Mock only external boundaries (network, database, file system); test internal logic with real implementations

3. **Generate edge case tests** — Add tests for boundary conditions and error paths:
   - Test with empty inputs (empty strings, empty arrays, null, undefined)
   - Test with boundary values (zero, negative numbers, maximum integer, single-element collections)
   - Test error handling paths — verify that invalid inputs throw the expected errors with meaningful messages
   - Test concurrent or async edge cases if the module uses promises or callbacks
   - Add a dedicated `describe('edge cases')` block to group these tests clearly

4. **Add property-based tests** — Generate PBT tests for functions with broad input domains:
   - Identify pure functions and data transformations suitable for property testing
   - Define properties that must hold for all valid inputs — e.g., round-trip (encode then decode returns original), idempotency, ordering preservation, length invariants
   - Write smart generators that constrain inputs to the function's valid domain rather than generating arbitrary data
   - Use the project's PBT library (`fast-check`, `hypothesis`, `jqwik`, or equivalent)
   - Add a dedicated `describe('properties')` block with clear property names — e.g., `for all valid users, serialization is reversible`

5. **Finalize and validate** — Clean up the generated test file and verify it runs:
   - Add required imports for the test framework, PBT library, and the module under test
   - Add a module-level doc comment summarizing what the test file covers
   - Ensure all tests follow the project's naming and formatting conventions
   - Run the test suite to confirm all tests pass and no imports are missing

## Expected Output

A test file at the output path (or co-located next to the source module) containing organized `describe` blocks with unit tests, edge case tests, and property-based tests. All tests pass on first run, follow the Arrange-Act-Assert pattern, and use descriptive names. The file is ready to commit with no additional edits required.

## Notes

- The skill generates tests based on the module's current exports. Re-run it after adding new functions to get updated coverage.
- Property-based tests are only generated for pure functions and data transformations. Side-effectful functions get unit and edge case tests only.
- If the module has complex external dependencies, the skill creates minimal boundary mocks. Replace these with fakes or in-memory implementations for more realistic testing.
- Adjust the coverage focus to generate only the test types you need — useful when adding PBT to a module that already has unit tests.
- The generated PBT generators are a starting point. Refine them to match your domain's constraints more precisely (e.g., valid email formats, realistic date ranges).
- For large modules with many exports, consider splitting the generated test file into multiple focused test files after generation.