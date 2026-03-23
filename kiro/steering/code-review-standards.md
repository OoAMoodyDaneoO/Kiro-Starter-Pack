# Code Review Standards

<!-- Scope: Global -->
<!-- Description: Enforce consistent, constructive, and thorough code review practices across all projects -->

## Overview

These standards define the code review rules that Kiro enforces when providing feedback on code changes. All rules are language-agnostic and apply regardless of the programming language, framework, or team size. The goal is to ensure every review is focused, constructive, and drives measurable improvement in code quality.

## Rules

### Review Scope

- **Correctness first — Verify the code does what it claims**: Every review must confirm that the code correctly implements the intended behavior. Check that logic handles all specified cases, return values are accurate, and state transitions are valid. Correctness issues are always blocking.
- **Readability — Ensure the code is easy to follow**: Review for clear naming, logical structure, and appropriate abstraction level. Code should be understandable by a teammate unfamiliar with the change. If you need to re-read a block multiple times to understand it, flag it for simplification.
- **Maintainability — Evaluate long-term cost of the change**: Assess whether the code is easy to modify, extend, and debug in the future. Flag tight coupling, duplicated logic, missing abstractions, and overly clever solutions that sacrifice clarity. Prefer simple, boring code over complex, elegant code.
- **Scope discipline — Review only what the change intends**: Focus feedback on the code that is part of the current change. Do not request unrelated refactors or improvements to surrounding code unless they are directly impacted by the change. File separate issues for pre-existing problems.
- **Consistency — Verify alignment with project conventions**: Check that the change follows established project patterns, naming conventions, file organization, and architectural decisions. Deviations from convention require explicit justification in the PR description or code comments.

### Feedback Tone

- **Constructive — Frame feedback as suggestions, not commands**: Use phrasing like "Consider using..." or "This could be simplified by..." rather than "This is wrong" or "Don't do this." The goal is to help the author improve, not to criticize.
- **Specific — Point to exact lines and explain the concern**: Every piece of feedback must reference the specific code it applies to and explain what the issue is. Vague comments like "This needs work" or "Clean this up" are not actionable and must be avoided.
- **Actionable — Provide a clear path to resolution**: Each comment must include enough context for the author to understand what to change and why. When possible, suggest a concrete alternative or link to a relevant guideline. Do not leave the author guessing.
- **Proportional — Match severity to impact**: Distinguish between critical issues (bugs, security flaws, data loss risks), suggestions (style improvements, minor refactors), and nits (formatting, naming preferences). Label feedback by severity so the author can prioritize effectively.
- **Respectful — Assume good intent and acknowledge effort**: Recognize that the author made deliberate choices. Ask clarifying questions before assuming a mistake. Acknowledge well-written code and good decisions alongside areas for improvement.

### Review Checklists

- **Error handling — Verify all failure paths are covered**: Confirm that the code handles errors explicitly, propagates them with context, and does not swallow exceptions silently. Check for missing try/catch blocks, unhandled promise rejections, and unchecked return values.
- **Edge cases — Test boundary conditions and unusual inputs**: Verify that the code handles empty collections, null or undefined values, zero-length strings, maximum and minimum numeric values, concurrent access, and other boundary conditions relevant to the domain.
- **Performance — Identify unnecessary computation or resource waste**: Check for N+1 queries, unbounded loops, missing pagination, excessive memory allocation, redundant API calls, and missing caching opportunities. Flag any operation that scales poorly with input size.
- **Security — Scan for common vulnerability patterns**: Check for unsanitized user input, SQL injection vectors, hardcoded secrets, missing authentication checks, overly permissive CORS or IAM policies, and unencrypted sensitive data. Security issues are always blocking.
- **Test coverage — Confirm changes are tested**: Verify that new logic has corresponding unit tests, edge case tests are present for complex paths, and existing tests are updated to reflect behavioral changes. Untested code paths must be flagged.

### Approval Criteria

- **All critical issues resolved — No blocking feedback remains open**: A change must not be approved while any critical issue (bug, security flaw, data integrity risk, or correctness failure) remains unresolved. The author must address every blocking comment before the reviewer approves.
- **Tests pass — All automated checks are green**: The change must pass all automated tests, linting, type checking, and CI pipeline checks before approval. Do not approve changes with failing tests, even if the failures appear unrelated.
- **Documentation updated — Public changes are documented**: If the change modifies a public API, configuration option, or user-facing behavior, the corresponding documentation must be updated in the same change. Do not approve changes that introduce undocumented behavior.
- **Scope verified — The change matches its description**: Confirm that the change does what the PR description says and does not include unrelated modifications. Out-of-scope changes should be split into separate PRs to keep reviews focused and history clean.
