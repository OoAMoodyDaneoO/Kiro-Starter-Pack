# Documentation Standards

<!-- Scope: Global -->
<!-- Description: Enforce comprehensive, consistent documentation across READMEs, APIs, inline comments, and changelogs -->

## Overview

These standards define the documentation rules that Kiro enforces during code generation and review. All rules are language-agnostic and apply regardless of the programming language, framework, or project type. The goal is to ensure every project is well-documented, easy to onboard onto, and maintainable over time.

## Rules

### README Structure

- **Project description — Start with a clear summary of what the project does**: Every README must begin with a concise description of the project's purpose, who it is for, and what problem it solves. A reader should understand the project's value within the first paragraph without reading any code.
- **Setup instructions — Provide step-by-step environment and installation guidance**: Include prerequisites (runtime versions, system dependencies), installation commands, and environment configuration steps. A new contributor should be able to go from a fresh clone to a running project by following the README alone.
- **Usage examples — Show how to use the project with concrete examples**: Include at least one usage example demonstrating the primary workflow or API. Use realistic inputs and expected outputs. For libraries, show import statements and function calls. For CLIs, show command invocations with sample output.
- **Contributing guidelines — Explain how others can contribute**: Include a contributing section or link to a `CONTRIBUTING.md` file that covers how to report issues, submit pull requests, run tests locally, and follow the project's coding standards. Lower the barrier to contribution by being explicit about expectations.
- **Table of contents — Add navigation for longer READMEs**: READMEs with more than four sections must include a table of contents with anchor links to each major section. This helps readers jump directly to the information they need without scrolling through the entire document.

### API Documentation

- **Parameter descriptions — Document every parameter with type and purpose**: Every public function, method, or endpoint must document each parameter including its name, type, whether it is required or optional, default value if applicable, and a brief description of its purpose. Use the language's standard doc format (JSDoc, docstrings, Javadoc, or equivalent).
- **Return types — Specify what the function returns**: Document the return type and describe what the returned value represents. For functions that return complex objects, describe the shape of the object. For functions that return nothing, state it explicitly. For async functions, document the resolved value type.
- **Usage examples — Include at least one example per public interface**: Every public function, class, or API endpoint must include at least one usage example in its documentation. Show the function call with realistic arguments and the expected return value. Examples serve as both documentation and informal tests.
- **Error documentation — Describe possible failure modes**: Document the exceptions, error codes, or error responses that a function or endpoint can produce. Explain under what conditions each error occurs and how the caller should handle it. Do not leave consumers guessing about failure behavior.
- **Deprecation notices — Mark deprecated interfaces clearly**: When a public interface is deprecated, add a visible deprecation notice in its documentation that states the version it was deprecated in, the recommended replacement, and the planned removal timeline. Never silently remove a public interface without a deprecation period.

### Inline Comments

- **Complex logic — Explain non-trivial algorithms and business rules**: Add inline comments before any block of code that implements a non-obvious algorithm, applies a business rule, or uses a technique that requires domain knowledge to understand. The comment should explain the intent and reasoning, not restate the code.
- **Non-obvious decisions — Document why, not what**: When the code makes a choice that might surprise a future reader (e.g., using a specific data structure for performance, handling a known edge case, working around a library bug), add a comment explaining the reasoning behind the decision. Link to relevant issues or documentation when available.
- **Workarounds and hacks — Flag temporary solutions with context**: When code includes a workaround for a known bug, library limitation, or platform quirk, add a comment that explains the issue, links to the upstream bug or reference, and describes when the workaround can be removed. Use `// HACK:` or `// WORKAROUND:` prefixes for visibility.
- **Avoid redundant comments — Do not restate what the code already says**: Comments like `// increment counter` above `counter++` add noise without value. Only comment when the code's intent is not self-evident from its structure and naming. Prefer improving variable and function names over adding explanatory comments.
- **Keep comments current — Update comments when code changes**: Stale comments that describe behavior the code no longer exhibits are worse than no comments at all. When modifying code, review and update any adjacent comments to ensure they remain accurate. Delete comments that no longer apply.

### Changelog Maintenance

- **Breaking changes — Document all backward-incompatible changes prominently**: Every breaking change must be documented in the changelog under a clearly labeled "Breaking Changes" section. Include what changed, why it changed, and what consumers need to do to migrate. Breaking changes must never be buried in a list of minor updates.
- **New features — Record all user-facing additions**: Every new feature, endpoint, configuration option, or capability must be documented in the changelog under a "Features" or "Added" section. Include a brief description of what was added and a reference to the relevant issue or pull request.
- **Bug fixes — Log all resolved defects**: Every bug fix must be documented in the changelog under a "Bug Fixes" or "Fixed" section. Include a brief description of the bug, the impact it had, and a reference to the issue that reported it. This helps users understand whether an upgrade addresses a problem they have encountered.
- **Versioning alignment — Tie changelog entries to version numbers**: Each changelog entry must be grouped under a version number and release date. Follow semantic versioning (major.minor.patch) so that consumers can assess the scope of changes at a glance. Unreleased changes should be grouped under an "Unreleased" heading until a version is cut.
- **Consistent format — Follow Keep a Changelog conventions**: Use a standardized changelog format such as [Keep a Changelog](https://keepachangelog.com/). Organize entries under consistent headings (Added, Changed, Deprecated, Removed, Fixed, Security). Consistent formatting makes changelogs machine-parseable and human-readable.
