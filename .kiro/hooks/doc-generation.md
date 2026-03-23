# Hook: Documentation Generation

<!-- Trigger: on-save — activates whenever a file with public API changes is saved -->
<!-- Description: Automatically generates or updates documentation when public APIs are modified -->

## Description

<!-- This hook watches for file save events on source code files that expose public APIs
     and instructs Kiro to generate or update the corresponding documentation. It keeps
     docs in sync with implementation changes so public interfaces are never undocumented
     or stale. -->

This hook fires whenever a source file containing public API definitions is saved. Kiro
analyzes the saved file, detects changes to exported functions, classes, interfaces, and
endpoints, then generates or updates the relevant documentation — including JSDoc/docstring
comments, README API sections, and standalone API reference files. Existing manually written
documentation is preserved; only new or changed public interfaces trigger doc updates.

## Trigger

<!-- The event type that activates this hook. "on-save" means it runs each time
     the user saves a file that matches the conditions below. -->
- **Event**: file saved (on-save)

<!-- Conditions filter which saved files actually trigger the action. Only files that
     define or modify public APIs should fire this hook — internal helpers, tests, and
     configuration files are excluded to avoid unnecessary doc generation. -->
- **Conditions**:
  - Only source code files: `*.ts`, `*.js`, `*.tsx`, `*.jsx`, `*.py`, `*.java`, `*.go`, `*.rs`
  - Only files with public exports: skip files that contain no exported functions, classes, or interfaces
  - Exclude test files: skip files matching `*.test.*`, `*.spec.*`, `*_test.*`
  - Exclude generated files: skip files in `node_modules/`, `dist/`, `build/`, `.kiro/`
  - Exclude configuration files: skip `*.json`, `*.yaml`, `*.yml`, `*.toml`, `*.config.*`

## Action

<!-- Detailed description of what Kiro does when the hook fires. The action runs
     automatically after the trigger conditions are met. -->

When a matching source file is saved, Kiro performs the following:

1. **Identify public API surface** — Parse the saved file to extract all public functions,
   classes, methods, interfaces, type aliases, and HTTP endpoint definitions that form the
   module's public API.
2. **Detect changes** — Compare the current public API surface against the previously
   documented state to identify new, modified, renamed, or removed public interfaces.
3. **Update inline documentation** — Add or update JSDoc, docstrings, or equivalent
   inline doc comments for each public symbol. Include parameter descriptions, return
   types, thrown exceptions, and a brief usage example where appropriate.
4. **Update API reference docs** — If the project maintains standalone API reference files
   (e.g., `docs/api.md` or a generated docs directory), update the relevant sections to
   reflect the current public API. Add entries for new exports and mark removed ones as
   deprecated.
5. **Flag undocumented interfaces** — If any public symbol cannot be auto-documented
   confidently (e.g., complex business logic requiring human context), flag it with a
   `// TODO: Add documentation` comment and notify the developer.
6. **Preserve manual documentation** — Never overwrite or remove documentation that was
   written manually. Only add or update generated doc blocks, leaving hand-written
   explanations intact.

## Configuration

<!-- Inline comments explaining configurable parameters. Users can adjust these
     values to match their project's documentation conventions. -->

<!-- file_patterns: Glob patterns for source files that trigger this hook.
     Add or remove patterns to match your project's language stack. -->
<!-- doc_style: The documentation comment style to use.
     Options: "jsdoc" (JavaScript/TypeScript), "docstring" (Python), "javadoc" (Java),
     "godoc" (Go), "rustdoc" (Rust). Auto-detected from file extension if not specified. -->
<!-- include_examples: Whether to generate usage examples in doc comments.
     Set to true for public library APIs, false for internal services. Default: true. -->
<!-- api_reference_path: Path to the standalone API reference file or directory.
     If set, the hook updates this file in addition to inline docs.
     Example: "docs/api.md" or "docs/api/" -->
<!-- deprecation_notice: Whether to add deprecation notices for removed public symbols
     instead of deleting their documentation. Default: true. -->
<!-- steering_files: List of steering files to apply during doc generation.
     By default, documentation-standards.md is used. Override to apply additional
     rules from other steering files. -->
