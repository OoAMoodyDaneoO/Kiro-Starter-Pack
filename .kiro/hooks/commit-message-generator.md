# Hook: Commit Message Generator

<!-- Trigger: pre-commit / on-demand — activates before a commit or when manually invoked -->
<!-- Description: Generates a commit message summary based on staged changes -->

## Description

<!-- This hook analyzes the staged diff and produces a concise, conventional commit
     message summarizing the changes. It can run automatically during the pre-commit
     workflow or be invoked on demand when the developer wants help writing a message. -->

This hook examines all staged changes and generates a structured commit message that
accurately describes what was changed and why. It follows conventional commit format
(type, scope, summary) and groups related changes into a coherent description. The
developer can accept the generated message as-is, edit it, or discard it entirely.

## Trigger

<!-- The event type that activates this hook. "pre-commit / on-demand" means it can
     run automatically before a commit is recorded or be triggered manually by the
     developer at any time. -->
- **Event**: pre-commit / on-demand

<!-- Conditions filter when the hook actually generates a message. It should only
     run when there are meaningful staged changes to summarize. -->
- **Conditions**:
  - Only when files are staged: do not trigger if `git diff --cached` is empty
  - Skip merge commits: do not generate messages for merge conflict resolutions
  - Skip amend commits: do not overwrite messages when amending an existing commit

## Action

<!-- Detailed description of what Kiro does when the hook fires. The action runs
     automatically after the trigger conditions are met. -->

When triggered with staged changes, Kiro performs the following:

1. **Collect the staged diff** — Retrieve the full diff of all staged files using
   `git diff --cached` along with the list of added, modified, and deleted files.
2. **Classify the change type** — Determine the primary type of change based on the
   diff content: `feat` (new feature), `fix` (bug fix), `refactor` (code restructuring),
   `docs` (documentation), `test` (test additions or updates), `chore` (maintenance),
   `style` (formatting), or `ci` (CI/CD changes).
3. **Identify the scope** — Detect the most relevant scope from the changed file paths
   (e.g., module name, directory, or component) to include in the commit message.
4. **Summarize the changes** — Write a concise summary line (50 characters or fewer)
   describing the primary change, followed by an optional body with additional detail
   for complex commits.
5. **List notable changes** — If multiple files or concerns are involved, add a bulleted
   list in the commit body highlighting the key changes grouped by category.
6. **Present the message** — Display the generated commit message to the developer for
   review. The developer can accept, edit, or discard the message before finalizing
   the commit.

## Configuration

<!-- Inline comments explaining configurable parameters. Users can adjust these
     values to match their project conventions and commit message preferences. -->

<!-- format: The commit message convention to follow.
     Options: "conventional" (type(scope): summary), "angular" (Angular convention),
     "freeform" (no enforced structure). Default: "conventional". -->
<!-- max_summary_length: Maximum character length for the summary line.
     Most conventions recommend 50 characters. Default: 50. -->
<!-- include_body: Whether to generate a detailed body for multi-file commits.
     Set to false for summary-only messages. Default: true. -->
<!-- include_breaking_change: Whether to detect and flag breaking changes with
     a "BREAKING CHANGE:" footer. Default: true. -->
<!-- exclude_patterns: Glob patterns for files to ignore when generating the message.
     Common exclusions: lock files, generated code. Example: "*.lock", "dist/**" -->
<!-- language: The natural language for the commit message.
     Default: "en" (English). Change to match your team's preferred language. -->
