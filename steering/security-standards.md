# Security Standards

<!-- Scope: Global -->
<!-- Description: Prevent common security vulnerabilities by enforcing input validation, secret management, dependency hygiene, auth, and output encoding -->

## Overview

These standards define the security rules that Kiro enforces during code generation and review. All rules are language-agnostic and apply regardless of the programming language, framework, or deployment target. The goal is to prevent common vulnerability classes — injection, credential exposure, supply chain attacks, broken access control, and data leakage — before they reach production.

## Rules

### Input Validation

- **Validate all external inputs — Never trust data from outside the trust boundary**: Every value originating from an external source (HTTP request parameters, headers, body, query strings, file uploads, environment variables read at runtime, message queue payloads, third-party API responses) must be validated before use. Define an explicit allow-list of acceptable values, types, lengths, and ranges. Reject anything that does not match.
- **Sanitize before processing — Strip or escape dangerous characters**: After validation, sanitize inputs by removing or escaping characters that could alter program behavior in downstream contexts (SQL, HTML, shell, LDAP, XML). Use framework-provided sanitization functions rather than hand-rolled regex.
- **Use schema validation — Enforce structure with a schema library**: For structured inputs (JSON, XML, form data), validate against a schema definition (JSON Schema, Zod, Joi, Pydantic, or equivalent). Schema validation catches type mismatches, missing required fields, and unexpected properties in a single declarative step.
- **Reject oversized inputs — Enforce size limits on all payloads**: Set and enforce maximum size limits on request bodies, file uploads, query strings, and individual field lengths. Unbounded inputs enable denial-of-service attacks and buffer-related vulnerabilities.
- **Validate on the server — Never rely solely on client-side validation**: Client-side validation improves user experience but provides no security guarantee. All validation logic must execute on the server (or the trusted backend) regardless of whether the client also validates.

### Secret Management

- **No hardcoded credentials — Never embed secrets in source code**: Passwords, API keys, tokens, connection strings, private keys, and any other secret material must never appear as string literals in source code, configuration files committed to version control, or CI/CD pipeline definitions. Use environment variables, a secrets manager (AWS Secrets Manager, HashiCorp Vault, Azure Key Vault), or encrypted configuration stores.
- **Use environment variables or a secrets manager — Externalize all secrets**: Load secrets at runtime from environment variables or a dedicated secrets management service. Reference secrets by name, not by value. In infrastructure-as-code templates, use `${VAR_NAME}` placeholder syntax or parameter store references.
- **Rotate secrets regularly — Automate credential rotation**: All secrets must have a defined rotation schedule. Use automated rotation mechanisms provided by your secrets manager. Applications must handle credential refresh without downtime or manual intervention.
- **Restrict secret access — Apply least-privilege to secret retrieval**: Only the services and roles that need a secret should have permission to read it. Use IAM policies, access control lists, or vault policies to scope secret access to the minimum required principals.
- **Audit secret access — Log all secret retrieval events**: Enable audit logging on your secrets manager to track who accessed which secret and when. Monitor for anomalous access patterns such as unexpected principals or high-frequency retrievals.

### Dependency Management

- **Pin dependency versions — Lock exact versions in manifests**: All dependency versions must be pinned to exact versions (not ranges) in lock files (`package-lock.json`, `poetry.lock`, `go.sum`, `Cargo.lock`). This ensures reproducible builds and prevents silent introduction of compromised versions.
- **Scan for vulnerabilities — Run automated security scans on every build**: Integrate a dependency vulnerability scanner (npm audit, Snyk, Dependabot, OWASP Dependency-Check, or equivalent) into the CI/CD pipeline. Fail the build if critical or high-severity vulnerabilities are detected in any dependency.
- **Review new dependencies — Evaluate before adding**: Before adding a new dependency, evaluate its maintenance status (last commit, open issues, bus factor), license compatibility, download count, and known vulnerability history. Prefer well-maintained, widely-used libraries over obscure alternatives.
- **Remove unused dependencies — Keep the dependency tree lean**: Regularly audit the dependency tree and remove packages that are no longer imported or used. Unused dependencies increase the attack surface without providing value.
- **Monitor for advisories — Subscribe to security notifications**: Subscribe to security advisory feeds for all direct dependencies (GitHub Security Advisories, NVD, language-specific advisory databases). Act on critical advisories within 48 hours.

### Authentication and Authorization

- **Use token-based authentication — Prefer JWTs or opaque tokens over session cookies**: Authenticate API consumers using token-based mechanisms (JWT, OAuth 2.0 access tokens, or API keys for service-to-service calls). Validate token signature, issuer, audience, and expiration on every request. Do not accept expired or malformed tokens.
- **Implement role-based access control — Enforce RBAC on all protected endpoints**: Every protected endpoint must check that the authenticated principal has the required role or permission before executing the operation. Define roles with the minimum permissions needed. Never grant blanket admin access to application-level roles.
- **Enforce least-privilege — Grant minimum required permissions**: Users and service accounts must receive only the permissions they need to perform their function. Review and prune permissions regularly. Prefer fine-grained permissions (e.g., `read:users`, `write:orders`) over coarse-grained ones (e.g., `admin`).
- **Secure token storage — Protect tokens at rest and in transit**: Store tokens securely on the client side (HTTP-only cookies, secure storage APIs). Never store tokens in local storage or expose them in URLs. Transmit tokens only over HTTPS.
- **Implement token expiration and refresh — Limit token lifetime**: Access tokens must have a short expiration time (minutes to hours, not days). Use refresh tokens with longer lifetimes to obtain new access tokens without re-authentication. Revoke refresh tokens on logout or suspected compromise.

### Output Encoding

- **Encode output for context — Apply context-appropriate encoding**: All dynamic data inserted into output must be encoded for the target context: HTML entity encoding for HTML content, JavaScript encoding for inline scripts, URL encoding for query parameters, CSS encoding for style contexts, and SQL parameterization for database queries. Never insert raw user input into any output context.
- **Use parameterized queries — Prevent SQL injection**: All database queries must use parameterized queries or prepared statements. Never concatenate user input into SQL strings. This applies to all database access layers including ORMs, raw SQL, and stored procedure calls.
- **Prevent XSS — Escape all user-controlled content in HTML output**: Any user-controlled data rendered in HTML must be escaped using the framework's built-in escaping mechanism. Disable raw HTML rendering by default. If raw HTML is required, sanitize it with a trusted library (DOMPurify, Bleach, or equivalent) that strips dangerous tags and attributes.
- **Set security headers — Configure HTTP response headers**: Set security-related HTTP headers on all responses: `Content-Security-Policy` to restrict resource loading, `X-Content-Type-Options: nosniff` to prevent MIME sniffing, `X-Frame-Options: DENY` to prevent clickjacking, `Strict-Transport-Security` to enforce HTTPS, and `Referrer-Policy` to control referrer information leakage.
- **Avoid template injection — Use safe templating engines**: Use templating engines that auto-escape output by default (Jinja2 with autoescape, React JSX, Handlebars with escaping). Never use `eval()`, `innerHTML`, or equivalent unsafe rendering methods with user-controlled data.
