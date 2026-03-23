# Hook: Pre-Commit Review

<!-- Trigger: pre-commit — activates before code is committed to version control -->
<!-- Description: Reviews staged changes and provides feedback before code is committed -->

## Description

<!-- This hook intercepts the commit workflow and instructs Kiro to review all staged
     changes before they are committed. It acts as an automated first-pass code review,
     catching common issues early so they never enter the repository history. -->

This hook runs automatically before a commit is finalized. Kiro examines the staged diff,
evaluates it against the project's coding standards, security rules, and best practices,
then provides structured feedback. If critical issues are found, the developer can address
them before committing. The goal is to maintain a clean commit history and reduce the
burden on human code reviewers.

## Trigger

<!-- The event type that activates this hook. "pre-commit" means it runs after the
     developer initiates a commit but before the commit is recorded. -->
- **Event**: pre-commit

<!-- Conditions filter which commits actually trigger the full review. Small or
     trivial commits can optionally skip the review to avoid slowing down the workflow. -->
- **Conditions**:
  - Only staged files: review is scoped to `git diff --cached`, not the entire working tree
  - Skip empty commits: do not trigger if no files are staged
  - Skip merge commits: do not trigger on merge conflict resolution commits
  - Include all file types: review source code, configuration, IaC templates, and documentation

## Action

<!-- Detailed description of what Kiro does when the hook fires. The action runs
     automatically after the trigger conditions are met. -->

When a commit is initiated with staged changes, Kiro performs the following:

1. **Collect the staged diff** — Retrieve the full diff of all staged files using
   `git diff --cached` to scope the review to only the changes being committed.
2. **Categorize changes** — Group the staged changes by type: source code, tests,
   configuration, documentation, and infrastructure. This allows targeted review rules
   for each category.
3. **Review for correctness** — Check for obvious bugs, logic errors, off-by-one mistakes,
   null/undefined handling gaps, and incomplete error handling in the changed code.
4. **Review for style and standards** — Evaluate naming conventions, formatting, and
   documentation against the project's steering files (coding-standards.md, etc.).
5. **Review for security** — Scan for hardcoded secrets, unsanitized inputs, SQL injection
   vectors, and other common vulnerability patterns in the staged changes.
6. **Generate feedback report** — Produce a structured summary with findings grouped by
   severity: critical (must fix before commit), warning (should fix soon), and info
   (suggestions for improvement).
7. **Present results** — Display the feedback to the developer so they can decide whether
   to proceed with the commit, amend the staged changes, or abort.

## Configuration

<!-- Inline comments explaining configurable parameters. Users can adjust these
     values to match their project conventions and review preferences. -->

<!-- severity_threshold: The minimum severity level that blocks a commit.
     "critical" only blocks on critical issues; "warning" blocks on warnings too.
     Set to "none" to make the review advisory-only (never blocks). -->
<!-- review_categories: Which review categories to enable.
     Options: correctness, style, security, documentation, performance.
     Remove categories to speed up the review or focus on specific concerns. -->
<!-- max_diff_lines: Maximum number of changed lines to review in a single commit.
     Very large diffs are summarized instead of reviewed line-by-line to keep
     feedback timely. Default: 500. -->
<!-- exclude_patterns: Glob patterns for files to skip during review.
     Common exclusions: lock files, generated code, vendor directories.
     Example: "*.lock", "generated/**", "vendor/**" -->
<!-- steering_files: List of steering files to apply during the review.
     By default, all steering files in .kiro/steering/ are used. Override this
     to limit which rules are checked during pre-commit review. -->
