# Hook: Auto Test Generation

<!-- Trigger: on-save — activates whenever a source file is saved -->
<!-- Description: Automatically generates or updates unit tests when source files change -->

## Description

<!-- This hook watches for file save events on source code files and instructs Kiro
     to generate or update the corresponding unit test file. It keeps test coverage
     in sync with implementation changes without requiring manual intervention. -->

This hook fires whenever a source file is saved. Kiro analyzes the saved file, identifies
public functions, classes, and exported interfaces, then generates or updates the co-located
unit test file to cover new or modified code paths. Existing tests are preserved; only new
or changed functionality triggers test updates.

## Trigger

<!-- The event type that activates this hook. "on-save" means it runs each time
     the user saves a file that matches the conditions below. -->
- **Event**: file saved (on-save)

<!-- Conditions filter which saved files actually trigger the action. Without conditions,
     every file save would fire the hook — including test files, configs, and docs. -->
- **Conditions**:
  - Only source code files: `*.ts`, `*.js`, `*.tsx`, `*.jsx`, `*.py`, `*.java`, `*.go`, `*.rs`
  - Exclude test files: skip files matching `*.test.*`, `*.spec.*`, `*_test.*`
  - Exclude generated files: skip files in `node_modules/`, `dist/`, `build/`, `.kiro/`
  - Exclude configuration files: skip `*.json`, `*.yaml`, `*.yml`, `*.toml`, `*.config.*`

## Action

<!-- Detailed description of what Kiro does when the hook fires. The action runs
     automatically after the trigger conditions are met. -->

When a matching source file is saved, Kiro performs the following:

1. **Analyze the saved file** — Parse the file to identify all public functions, classes,
   methods, and exported interfaces that require test coverage.
2. **Locate existing tests** — Look for a co-located test file (e.g., `user-service.test.ts`
   next to `user-service.ts`). If none exists, create one.
3. **Diff against existing tests** — Compare the current source exports with the existing
   test cases to identify untested or modified code paths.
4. **Generate or update tests** — Write new test cases for untested functions and update
   existing tests whose source signatures or logic have changed. Follow the project's
   testing standards (Arrange-Act-Assert pattern, descriptive names).
5. **Preserve manual tests** — Never overwrite or remove tests that were written manually.
   Only add or update generated test blocks.

## Configuration

<!-- Inline comments explaining configurable parameters. Users can adjust these
     values to match their project conventions. -->

<!-- file_patterns: Glob patterns for source files that trigger this hook.
     Add or remove patterns to match your project's language stack. -->
<!-- test_suffix: The suffix used for test files (default: ".test").
     Change to ".spec" if your project uses that convention. -->
<!-- test_location: Where to place generated test files.
     "co-located" puts them next to source files; "dedicated" puts them in a tests/ directory. -->
<!-- framework: The test framework to use for generated tests (e.g., vitest, jest, pytest, junit).
     Auto-detected from project config if not specified. -->
