---
name: security-audit
description: "Perform a security audit scanning dependencies for vulnerabilities, analyzing code for security issues, and checking for exposed secrets. Use when assessing security posture."
---

## Description

Performs a security audit on a target codebase and generates a structured report of findings. The audit covers three areas: dependency vulnerabilities (outdated or compromised packages), code-level security issues (injection risks, insecure configurations, missing input validation), and secrets exposure (hardcoded credentials, API keys, or tokens in source files). Each finding includes a severity rating and actionable remediation steps.

When invoked, you'll need: the target directory to audit (e.g., `src/`, `.`, `services/auth/`) and the audit scope (`deps` for dependencies only, `code` for source code only, or `both` for a full audit). Optionally specify the primary language (auto-detected from manifests), severity threshold (default: `medium`), and output format (`markdown` or `json`; default: `markdown`).

## Steps

1. **Scan dependencies for known vulnerabilities** — Analyze package manifests and lock files for security issues:
   - Locate dependency manifests (`package.json`, `requirements.txt`, `pyproject.toml`, `pom.xml`, `go.mod`, `Cargo.toml`)
   - Parse lock files (`package-lock.json`, `poetry.lock`, `go.sum`, `Cargo.lock`) to identify exact installed versions
   - Cross-reference each dependency and version against known vulnerability databases (CVE, GitHub Advisories, OSV)
   - Flag dependencies with known critical or high-severity vulnerabilities
   - Identify outdated dependencies that are multiple major versions behind the latest release
   - Record each finding with the package name, installed version, patched version, CVE identifier, and severity rating

2. **Analyze source code for security vulnerabilities** — Scan source files for common vulnerability patterns:
   - Check for SQL injection risks — string concatenation in database queries instead of parameterized statements
   - Check for command injection risks — unsanitized input passed to shell execution functions (`exec`, `spawn`, `os.system`)
   - Check for cross-site scripting (XSS) risks — unescaped user input rendered in HTML templates or `innerHTML` assignments
   - Check for insecure deserialization — use of `eval()`, `pickle.loads()`, or equivalent on untrusted data
   - Check for missing input validation — public API endpoints or functions that accept external input without validation
   - Check for insecure cryptographic practices — use of weak algorithms (MD5, SHA1 for hashing passwords), hardcoded IVs or salts
   - Check for overly permissive CORS or security header configurations
   - Record each finding with the file path, line number, vulnerability type, severity, and a code snippet

3. **Check for secrets exposure** — Scan the codebase for accidentally committed credentials:
   - Search for patterns matching API keys, tokens, passwords, and connection strings in source files
   - Check for common secret patterns: AWS access keys (`AKIA...`), PEM private key headers, JWT tokens, database connection URIs with embedded credentials
   - Scan configuration files (`.env`, `config.yaml`, `application.properties`) for plaintext secrets that should use environment variable references
   - Check `.gitignore` to verify that sensitive files (`.env`, `*.pem`, `*.key`) are excluded from version control
   - Verify that no secrets appear in test fixtures, seed data, or documentation examples
   - Record each finding with the file path, line number, secret type, and recommended remediation

4. **Generate audit report** — Compile all findings into a structured, actionable report:
   - Group findings by category: dependency vulnerabilities, code vulnerabilities, secrets exposure
   - Sort findings within each category by severity (critical → high → medium → low)
   - Include a summary section with total finding counts by severity and category
   - For each finding, provide: description, severity, affected file and line, and a specific remediation step
   - Add a recommendations section with prioritized next actions
   - Write the report in the requested output format

## Expected Output

A security audit report containing a summary of findings grouped by category and sorted by severity. Each finding includes the affected file, a description of the vulnerability, a severity rating, and a concrete remediation step. The report ends with a prioritized list of recommended actions to improve the project's security posture.

## Notes

- This skill performs static analysis only. It does not execute code, run penetration tests, or test live endpoints. Complement it with dynamic application security testing (DAST) for production systems.
- The dependency scan relies on manifest and lock files being present and up to date. Run your package manager's install or lock command before invoking this skill.
- Secret detection uses pattern matching and may produce false positives for test fixtures or example values. Review flagged items before taking action.
- For monorepos, run the skill on each service directory separately to get focused reports.
- Adjust the severity threshold to `critical` for a quick triage of the most urgent issues, or to `low` for a thorough baseline audit.
- The generated report is a point-in-time snapshot. Schedule regular re-runs (e.g., weekly or before each release) to catch newly disclosed vulnerabilities.