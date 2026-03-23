# Coding Standards

<!-- Scope: Global -->
<!-- Description: Enforce consistent code style, naming, formatting, documentation, and error handling across all projects -->

## Overview

These standards define the baseline code quality rules that Kiro enforces during code generation and review. All rules are language-agnostic and apply regardless of the programming language or framework in use.

## Rules

### Naming Conventions

- **Variables — Use descriptive camelCase**: Variable names must be descriptive and use camelCase (or the language's idiomatic equivalent). Avoid single-letter names except for loop counters or well-known conventions (e.g., `i`, `x`, `y`). Prefer names that reveal intent: `userCount` over `n`, `isEnabled` over `flag`.
- **Functions — Use verb-phrase camelCase**: Function and method names must start with a verb and use camelCase. The name should describe what the function does: `calculateTotal`, `fetchUserById`, `validateInput`. Avoid vague names like `process` or `handle` without further qualification.
- **Classes — Use PascalCase nouns**: Class and type names must use PascalCase and be singular nouns or noun phrases that describe the entity: `UserRepository`, `PaymentService`, `HttpClient`. Avoid prefixes like `I` for interfaces unless the language convention requires it.
- **Files — Use kebab-case matching exports**: File names must use kebab-case (e.g., `user-repository.ts`, `payment-service.py`). Each file name should reflect its primary export or purpose. Test files must use a `.test` or `.spec` suffix before the extension.
- **Constants — Use UPPER_SNAKE_CASE**: Module-level constants must use UPPER_SNAKE_CASE: `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT_MS`. Enum members should follow the same convention or PascalCase depending on language idiom.
- **Booleans — Use is/has/should prefixes**: Boolean variables and properties must use a prefix that reads as a question: `isActive`, `hasPermission`, `shouldRetry`.

### Code Formatting

- **Indentation — Use consistent spaces**: Use spaces for indentation (2 or 4 spaces depending on language convention). Never mix tabs and spaces within a project. Configure the project formatter to enforce this automatically.
- **Line length — Cap at 100 characters**: Lines must not exceed 100 characters. Break long expressions, function signatures, or chained calls across multiple lines for readability.
- **Bracket style — Use same-line opening braces**: Opening braces go on the same line as the statement (`if (condition) {`). Closing braces go on their own line, aligned with the opening statement. For languages without braces, follow the language's idiomatic block style.
- **Blank lines — Separate logical sections**: Use a single blank line to separate logical sections within a function and between top-level declarations. Do not use multiple consecutive blank lines. Group related statements together.
- **Trailing commas — Include in multiline structures**: Use trailing commas in multiline arrays, objects, parameter lists, and imports where the language supports it. This produces cleaner diffs.
- **Import ordering — Group and sort**: Organize imports into groups: standard library, external dependencies, internal modules. Sort alphabetically within each group. Separate groups with a blank line.

### Documentation Expectations

- **Function-level comments — Document purpose, params, and return**: Every public function must have a doc comment describing what it does, its parameters (with types if not statically typed), return value, and any exceptions it may throw. Use the language's standard doc format (JSDoc, docstrings, Javadoc, etc.).
- **Module-level descriptions — Add a top-of-file summary**: Every module or file must begin with a brief comment or docstring explaining its purpose and the key exports it provides. Keep it to 1–3 sentences.
- **Inline comments — Explain why, not what**: Use inline comments sparingly and only to explain non-obvious reasoning, business logic, or workarounds. Do not restate what the code already says. Prefer self-documenting code over comments.
- **TODO/FIXME annotations — Include context**: When leaving a TODO or FIXME, include a brief description of what needs to be done and, if possible, a reference to a ticket or issue number: `// TODO(#123): Add retry logic for transient failures`.

### Error Handling Patterns

- **Explicit propagation — Never swallow errors silently**: Every error must be explicitly handled or propagated to the caller. Catch blocks must either recover from the error, re-throw it, or log it with sufficient context. Empty catch blocks are never acceptable.
- **Meaningful error messages — Include context**: Error messages must describe what went wrong and include relevant context (input values, operation name, resource identifier). Avoid generic messages like "Something went wrong" or "Error occurred".
- **Typed errors — Use specific error types**: Prefer specific, typed error classes over generic exceptions. Create custom error types for distinct failure categories (e.g., `ValidationError`, `NotFoundError`, `AuthenticationError`). This enables callers to handle different failures appropriately.
- **Fail fast — Validate inputs early**: Validate function inputs at the top of the function body and throw or return errors immediately for invalid inputs. Do not let invalid data propagate deep into the call stack before failing.
- **Resource cleanup — Use finally or equivalent**: When acquiring resources (file handles, database connections, network sockets), always ensure cleanup using `finally`, `defer`, `using`, context managers, or the language's equivalent. Never rely on garbage collection alone for resource cleanup.
