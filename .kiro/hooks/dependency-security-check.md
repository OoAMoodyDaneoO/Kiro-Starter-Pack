# Hook: Dependency Security Check

<!-- Trigger: on-save — activates whenever a package manifest file is saved -->
<!-- Description: Checks newly added dependencies for known security vulnerabilities -->

## Description

<!-- This hook watches for file save events on package manifest files (package.json,
     requirements.txt, Gemfile, etc.) and instructs Kiro to check any newly added or
     updated dependencies against known vulnerability databases. It catches insecure
     dependencies at the moment they are introduced, before they reach version control. -->

This hook fires whenever a package manifest file is saved. Kiro diffs the manifest against
its previous state to identify newly added or version-changed dependencies, then checks each
one against known vulnerability databases (e.g., GitHub Advisory Database, NVD, OSV). If any
dependency has known critical or high-severity vulnerabilities, Kiro alerts the developer with
details and suggests safer alternatives or patched versions.

## Trigger

<!-- The event type that activates this hook. "on-save" means it runs each time
     the user saves a file that matches the conditions below. -->
- **Event**: file saved (on-save)

<!-- Conditions filter which saved files actually trigger the action. Only package
     manifest files should fire this hook — source code, tests, and other configs
     are excluded to avoid unnecessary vulnerability checks. -->
- **Conditions**:
  - Only package manifest files: `package.json`, `requirements.txt`, `Pipfile`, `pyproject.toml`, `Gemfile`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`, `build.gradle.kts`, `composer.json`
  - Exclude lock files: skip `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `Pipfile.lock`, `Gemfile.lock`, `go.sum`, `Cargo.lock`, `composer.lock` (lock files reflect resolved versions, not user intent)
  - Exclude files in `node_modules/`, `vendor/`, `.kiro/`

## Action

<!-- Detailed description of what Kiro does when the hook fires. The action runs
     automatically after the trigger conditions are met. -->

When a matching package manifest file is saved, Kiro performs the following:

1. **Diff the manifest** — Compare the current file content against the last committed
   version to identify newly added dependencies and version changes. Ignore removals
   and unchanged entries to keep the check focused.
2. **Resolve package metadata** — For each new or changed dependency, resolve the package
   name, requested version range, and the ecosystem (npm, PyPI, crates.io, Maven, etc.)
   based on the manifest file type.
3. **Query vulnerability databases** — Check each identified dependency and version against
   known vulnerability databases (GitHub Advisory Database, National Vulnerability Database,
   Open Source Vulnerabilities). Flag any dependency with known CVEs rated critical or high.
4. **Assess severity** — For each flagged vulnerability, extract the CVE identifier, severity
   score (CVSS), affected version range, and a brief description of the vulnerability.
5. **Suggest remediations** — For each vulnerable dependency, recommend a patched version
   if one exists, suggest an alternative package with equivalent functionality, or note if
   the vulnerability is disputed or not applicable to typical usage.
6. **Report findings** — Present a structured summary to the developer listing each
   vulnerable dependency, its severity, and the recommended action. If no vulnerabilities
   are found, confirm that all new dependencies passed the security check.

## Configuration

<!-- Inline comments explaining configurable parameters. Users can adjust these
     values to match their project's security policies and package ecosystem. -->

<!-- severity_threshold: The minimum CVE severity that triggers an alert.
     "critical" only flags critical vulnerabilities; "high" flags high and above;
     "medium" includes medium severity. Default: "high". -->
<!-- manifest_patterns: Glob patterns for package manifest files that trigger this hook.
     Add or remove patterns to match your project's language stack and package manager. -->
<!-- ignore_advisories: List of CVE IDs or advisory IDs to suppress.
     Use this for known false positives or accepted risks that have been reviewed.
     Example: ["CVE-2023-XXXXX", "GHSA-xxxx-xxxx-xxxx"] -->
<!-- check_transitive: Whether to also check transitive (indirect) dependencies.
     Requires a lock file to be present. Default: false (direct dependencies only). -->
<!-- vulnerability_sources: Which vulnerability databases to query.
     Options: "github-advisory", "nvd", "osv". Default: all available sources. -->
