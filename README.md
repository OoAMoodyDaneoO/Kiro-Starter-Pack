# Kiro Starter Kit

A ready-to-use template repository that gives you a fully configured [Kiro](https://kiro.dev) workspace out of the box. Clone it, open it in your IDE, and start building with best-practice steering files, automated hooks, custom agents, MCP integrations, and reusable skills — no setup required.

## Table of Contents

- [Quick Start](#quick-start)
- [Repository Structure](#repository-structure)
- [What's Included](#whats-included)
  - [Steering Files](#steering-files)
  - [Hooks](#hooks)
  - [Powers](#powers)
  - [Sub-Agents](#sub-agents)
  - [MCP Servers](#mcp-servers)
  - [Skills](#skills)
- [How Kiro Uses These Files](#how-kiro-uses-these-files)
- [Customization Guide](#customization-guide)
  - [Adding a Configuration](#adding-a-configuration)
  - [Modifying a Configuration](#modifying-a-configuration)
  - [Removing a Configuration](#removing-a-configuration)
  - [File Format Reference](#file-format-reference)
- [Recommended Powers](#recommended-powers)
- [Environment Variables](#environment-variables)
- [Validation](#validation)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/your-org/kiro-starter-kit.git
cd kiro-starter-kit
```

### 2. Open in your IDE with Kiro

Open the cloned folder in your IDE. Kiro automatically detects the `.kiro/` directory and loads all steering files, hooks, agents, and skills.

### 3. Verify the setup

Check that Kiro has loaded the starter kit by looking at the Kiro panel — you should see steering files, hooks, and agents listed. You can also run the validation script:

```bash
chmod +x validate.sh
./validate.sh
```

### 4. Configure MCP servers (optional)

If you plan to use the MCP server integrations, set the required environment variables. See the [Environment Variables](#environment-variables) section for the full list.

### 5. Install recommended powers (optional)

Open the Kiro IDE Powers panel and install any powers relevant to your stack. See [Recommended Powers](#recommended-powers) for suggestions.

### 6. Customize

The kit is yours. Every file is independent — add, modify, or remove any configuration to match your team's workflow. See the [Customization Guide](#customization-guide) for details.

---

## Repository Structure

```
kiro-starter-kit/
├── README.md                          # This file
├── LICENSE                            # MIT license
├── .gitignore                         # OS files, editor configs, env files
├── validate.sh                        # Structural validation script
└── .kiro/
    ├── steering/                      # Persistent rules for code generation and review
    │   ├── coding-standards.md        #   Naming, formatting, docs, error handling
    │   ├── testing-standards.md       #   Test organization, structure, PBT
    │   ├── aws-best-practices.md      #   IAM, tagging, encryption, logging, IaC
    │   ├── security-standards.md      #   Input validation, secrets, auth, encoding
    │   ├── code-review-standards.md   #   Review scope, tone, checklists, approval
    │   └── documentation-standards.md #   README, API docs, comments, changelogs
    │
    ├── hooks/                         # Event-driven workflow automations
    │   ├── auto-test-generation.md    #   Generate tests on file save
    │   ├── pre-commit-review.md       #   Review staged changes before commit
    │   ├── doc-generation.md          #   Update docs when APIs change
    │   ├── dependency-security-check.md # Check deps for vulnerabilities
    │   ├── iac-validation.md          #   Validate IaC templates on save
    │   └── commit-message-generator.md #  Generate commit messages
    │
    ├── agents/                        # Specialized AI sub-agents
    │   ├── code-reviewer.md           #   Code quality and style feedback
    │   ├── test-generator.md          #   Unit and property-based tests
    │   ├── doc-writer.md              #   Documentation generation
    │   ├── security-auditor.md        #   Vulnerability identification
    │   ├── refactoring-assistant.md   #   Code improvements
    │   ├── debugger.md                #   Error analysis and root cause
    │   ├── architecture-reviewer.md   #   System design evaluation
    │   ├── performance-optimizer.md   #   Bottleneck identification
    │   ├── ui-developer.md            #   UI components and styling
    │   ├── frontend-developer.md      #   Frontend app architecture
    │   ├── backend-developer.md       #   APIs, databases, auth
    │   └── deployment-engineer.md     #   CI/CD, containers, cloud infra
    │
    ├── skills/                        # On-demand workflow templates
    │   ├── scaffold-microservice/SKILL.md
    │   ├── generate-crud-api/SKILL.md
    │   ├── setup-cicd/SKILL.md
    │   ├── generate-db-migration/SKILL.md
    │   ├── create-frontend-component/SKILL.md
    │   ├── write-test-suite/SKILL.md
    │   ├── generate-api-client/SKILL.md
    │   ├── security-audit/SKILL.md
    │   ├── setup-monitoring/SKILL.md
    │   └── generate-iac/SKILL.md
    │
    ├── powers/                        # Installable power packages (see README)
    │   └── README.md
    │
    └── mcp.json                       # MCP server configurations
```

---

## What's Included

### Steering Files

**Directory:** [`.kiro/steering/`](.kiro/steering/)

Steering files give Kiro persistent knowledge about your project's standards. They are loaded automatically on every interaction and apply globally across all conversations. All rules are language-agnostic.

| File | What It Covers |
|------|----------------|
| [`coding-standards.md`](.kiro/steering/coding-standards.md) | Variable/function/class naming conventions, indentation and line length rules, bracket style, import ordering, function-level and module-level documentation expectations, error handling patterns (explicit propagation, no silent failures, typed errors, fail-fast validation) |
| [`testing-standards.md`](.kiro/steering/testing-standards.md) | Test file co-location vs dedicated directories, descriptive test naming, Arrange-Act-Assert structure, minimal mocking (prefer fakes over mocks), property-based testing with PBT libraries, test isolation and cleanup |
| [`aws-best-practices.md`](.kiro/steering/aws-best-practices.md) | Least-privilege IAM policies, required resource tags (Environment, Owner, CostCenter), encryption at rest and in transit with KMS, CloudTrail and CloudWatch monitoring, VPC Flow Logs, infrastructure-as-code with drift detection |
| [`security-standards.md`](.kiro/steering/security-standards.md) | Input validation and sanitization, secret management (no hardcoded credentials), dependency pinning and vulnerability scanning, token-based auth with RBAC, output encoding to prevent injection, security headers |
| [`code-review-standards.md`](.kiro/steering/code-review-standards.md) | Review scope (correctness first, then readability, then maintainability), constructive feedback tone, severity categorization (critical/suggestion/nit), checklists for error handling, edge cases, performance, and security |
| [`documentation-standards.md`](.kiro/steering/documentation-standards.md) | README structure (description, setup, usage, contributing), API documentation (params, return types, examples, errors), inline comments (explain why, not what), changelog maintenance (Keep a Changelog format) |

**How steering works:** Kiro reads these files at the start of every conversation. When you ask it to write code, review a PR, or generate tests, it applies these rules automatically. You never need to remind it about your coding standards.

### Hooks

**Directory:** [`.kiro/hooks/`](.kiro/hooks/)

Hooks automate development workflows by triggering Kiro actions in response to IDE events. They run without manual intervention.

| File | Trigger | What It Does |
|------|---------|--------------|
| [`auto-test-generation.md`](.kiro/hooks/auto-test-generation.md) | File save (source files) | Detects when you save a source file and generates or updates the corresponding unit test file. Follows the testing standards steering file for structure and naming. |
| [`pre-commit-review.md`](.kiro/hooks/pre-commit-review.md) | Pre-commit | Reviews all staged changes before you commit. Checks for bugs, style issues, missing tests, and security concerns. Provides feedback inline so you can fix issues before they enter the commit history. |
| [`doc-generation.md`](.kiro/hooks/doc-generation.md) | File save (public APIs) | Watches for changes to files with public interfaces. When a function signature, class, or endpoint changes, it updates the corresponding documentation automatically. |
| [`dependency-security-check.md`](.kiro/hooks/dependency-security-check.md) | File save (package manifests) | Triggers when `package.json`, `requirements.txt`, `go.mod`, or similar files are saved. Checks newly added dependencies against vulnerability databases and flags known issues. |
| [`iac-validation.md`](.kiro/hooks/iac-validation.md) | File save (IaC files) | Validates CloudFormation, Terraform, and CDK files on save. Checks for syntax errors, missing required fields, security misconfigurations, and best-practice violations. |
| [`commit-message-generator.md`](.kiro/hooks/commit-message-generator.md) | Pre-commit / on-demand | Analyzes staged changes and generates a conventional commit message summarizing what changed and why. Saves you from writing commit messages manually. |

**How hooks work:** Hooks are defined as markdown files that describe the trigger event and the action Kiro should take. Kiro monitors for the specified events and executes the action automatically. You can disable any hook by deleting its file.

### Powers

**Directory:** [`.kiro/powers/`](.kiro/powers/)

Powers are installable packages that add specialized context and tools to Kiro agents on-demand. Unlike steering files and hooks, powers are **not** manually created — they are installed from the Kiro IDE Powers panel or from GitHub repositories.

When you mention a topic that matches a power's keywords, Kiro automatically loads that power's context and tools into the conversation. This keeps your agent focused — a Terraform power only loads when you're working on infrastructure, not when you're writing React components.

Browse all available powers at [kiro.dev/powers](https://kiro.dev/powers/). See [`.kiro/powers/README.md`](.kiro/powers/README.md) for installation instructions and how to create your own.

### Sub-Agents

**Directory:** [`.kiro/agents/`](.kiro/agents/)

Sub-agents are specialized AI personas with focused system prompts and curated tool access. Instead of one general-purpose agent handling everything, you can route tasks to specialists that stay focused and manage their own context.

Kiro automatically selects the right agent based on its description, or you can invoke one explicitly.

**Review and Quality Agents:**

| File | Specialization | Tools |
|------|---------------|-------|
| [`code-reviewer.md`](.kiro/agents/code-reviewer.md) | Code quality, correctness, and style feedback. Categorizes findings by severity (critical/suggestion/nit). Never modifies files. | read, diagnostics |
| [`security-auditor.md`](.kiro/agents/security-auditor.md) | OWASP top 10, dependency vulnerabilities, secret exposure, input validation gaps. References CWE identifiers. | read, search, diagnostics |
| [`architecture-reviewer.md`](.kiro/agents/architecture-reviewer.md) | Separation of concerns, dependency direction, scalability, architectural pattern consistency. | read, list, search |
| [`performance-optimizer.md`](.kiro/agents/performance-optimizer.md) | Algorithmic complexity, N+1 queries, caching opportunities, resource leaks, unnecessary computation. | read, diagnostics, search |

**Generation and Modification Agents:**

| File | Specialization | Tools |
|------|---------------|-------|
| [`test-generator.md`](.kiro/agents/test-generator.md) | Unit tests, property-based tests, edge cases, error path coverage. Follows Arrange-Act-Assert. | read, write, diagnostics |
| [`doc-writer.md`](.kiro/agents/doc-writer.md) | READMEs, API reference docs, inline comments, changelogs. Reads code first, then writes accurate docs. | read, write |
| [`refactoring-assistant.md`](.kiro/agents/refactoring-assistant.md) | DRY, SOLID, complexity reduction, dead code removal. Preserves behavior, suggests incremental changes. | read, write, diagnostics |
| [`debugger.md`](.kiro/agents/debugger.md) | Stack trace analysis, log analysis, execution flow tracing, root cause identification. | read, search, shell |

**Role-Based Development Agents:**

| File | Specialization | Tools |
|------|---------------|-------|
| [`ui-developer.md`](.kiro/agents/ui-developer.md) | Components, styling, accessibility, responsive design, design tokens. Focuses on visual and interaction quality. | read, write, diagnostics |
| [`frontend-developer.md`](.kiro/agents/frontend-developer.md) | App architecture, routing, data fetching, state management, form handling, error boundaries. | read, write, shell, diagnostics |
| [`backend-developer.md`](.kiro/agents/backend-developer.md) | APIs, databases, authentication, business logic, data validation, request logging. | read, write, shell, diagnostics, search |
| [`deployment-engineer.md`](.kiro/agents/deployment-engineer.md) | CI/CD pipelines, Docker, cloud infrastructure, release management, monitoring setup. | read, write, shell, search |

**How agents work:** Each agent is a markdown file with YAML frontmatter (`description` and `tools`) followed by a system prompt. The `description` tells Kiro when to activate the agent. The `tools` list controls what the agent can access. The system prompt shapes the agent's behavior, focus areas, and output format.

### MCP Servers

**Configuration:** [`.kiro/mcp.json`](.kiro/mcp.json)

MCP (Model Context Protocol) servers connect Kiro to external tools and services. They extend what Kiro can do beyond reading and writing files — querying databases, searching the web, interacting with GitHub, and more.

| Server | Purpose | Package | Required Environment Variable |
|--------|---------|---------|-------------------------------|
| `filesystem` | File system operations and context gathering | `@modelcontextprotocol/server-filesystem` | `ALLOWED_DIRECTORIES` — comma-separated list of directories the server can access |
| `postgres` | Database querying and schema inspection | `@modelcontextprotocol/server-postgres` | `POSTGRES_CONNECTION_STRING` — full PostgreSQL connection URI |
| `brave-search` | Web search and knowledge retrieval | `@modelcontextprotocol/server-brave-search` | `BRAVE_API_KEY` — API key from [Brave Search API](https://brave.com/search/api/) |
| `github` | GitHub API integration (issues, PRs, repos) | `@modelcontextprotocol/server-github` | `GITHUB_TOKEN` — GitHub personal access token with appropriate scopes |

All sensitive values use `${VAR_NAME}` placeholder syntax in the config file. You set the actual values as environment variables on your machine — they are never committed to the repository.

### Skills

**Directory:** [`.kiro/skills/`](.kiro/skills/)

Skills are portable instruction packages that Kiro activates on-demand when your request matches the skill's description. Each skill is a folder containing a `SKILL.md` file with YAML frontmatter and step-by-step instructions.

Skills use progressive disclosure: at startup, Kiro only loads the name and description. The full instructions load into context only when the skill is relevant, keeping your context window lean.

| Skill | Category | What It Does | Example Prompt |
|-------|----------|--------------|----------------|
| [`scaffold-microservice`](.kiro/skills/scaffold-microservice/SKILL.md) | Scaffolding | Creates a new microservice with directory structure, boilerplate, build config, Dockerfile, and README | "Scaffold a new order-service in TypeScript with Express" |
| [`generate-crud-api`](.kiro/skills/generate-crud-api/SKILL.md) | Generation | Generates model, controller, routes, validation, and error handling for a resource | "Generate a CRUD API for products with title, price, and active fields" |
| [`setup-cicd`](.kiro/skills/setup-cicd/SKILL.md) | Setup | Creates CI/CD pipeline config with build, test, and deploy stages | "Set up GitHub Actions CI/CD for this Python project deploying to AWS Lambda" |
| [`generate-db-migration`](.kiro/skills/generate-db-migration/SKILL.md) | Generation | Generates a migration file with up/down methods from a schema description | "Add an email column to the users table" |
| [`create-frontend-component`](.kiro/skills/create-frontend-component/SKILL.md) | Scaffolding | Creates a component with typed props, styles, tests, and barrel export | "Create a SearchBar component in React with Tailwind styling" |
| [`write-test-suite`](.kiro/skills/write-test-suite/SKILL.md) | Generation | Generates unit tests, edge case tests, and property-based tests for a module | "Write a test suite for src/services/order-service.ts" |
| [`generate-api-client`](.kiro/skills/generate-api-client/SKILL.md) | Generation | Generates typed client code from an OpenAPI spec with models and service classes | "Generate a TypeScript API client from openapi.yaml" |
| [`security-audit`](.kiro/skills/security-audit/SKILL.md) | Audit | Scans dependencies, code, and secrets, then generates a findings report | "Run a security audit on the src/ directory" |
| [`setup-monitoring`](.kiro/skills/setup-monitoring/SKILL.md) | Setup | Creates monitoring config, health checks, alerts, and dashboard templates | "Set up monitoring for the payment-service on AWS ECS" |
| [`generate-iac`](.kiro/skills/generate-iac/SKILL.md) | Generation | Generates IaC templates from a plain-language architecture description | "Generate Terraform for a VPC with an ALB, ECS Fargate, and RDS Postgres" |

---

## How Kiro Uses These Files

Understanding how each configuration type loads helps you decide where to put things:

| Type | When It Loads | Scope | Format |
|------|--------------|-------|--------|
| **Steering files** | Every conversation, automatically | Always active | Markdown in `.kiro/steering/` |
| **Hooks** | On specific IDE events (file save, pre-commit) | Event-driven | Markdown in `.kiro/hooks/` |
| **Agents** | When Kiro matches your request to an agent's description, or when you invoke one explicitly | On-demand | Markdown with YAML frontmatter in `.kiro/agents/` |
| **Skills** | When your request matches a skill's description (only metadata loads at startup, full content on-demand) | On-demand | `SKILL.md` with YAML frontmatter in `.kiro/skills/<name>/` |
| **Powers** | When conversation keywords match a power's keywords | On-demand | Installed via IDE panel or GitHub |
| **MCP servers** | When an agent needs external tool access | On-demand | JSON in `.kiro/mcp.json` |

---

## Customization Guide

Every file in this kit is independent — you can add, modify, or remove any configuration without affecting the others.

### Adding a Configuration

**Steering file:** Create a new `.md` file in `.kiro/steering/`. Add a `<!-- Scope: Global -->` comment and organize rules under `## Rules` with `### Category` subsections. Kiro loads it automatically on the next conversation.

**Hook:** Create a new `.md` file in `.kiro/hooks/`. Define the trigger event, conditions, and action. See existing hooks for the expected structure.

**Agent:** Create a new `.md` file in `.kiro/agents/` with YAML frontmatter:

```markdown
---
description: "What this agent does. Use when [specific scenarios]."
tools:
  - read
  - write
  - diagnostics
---

You are a [role]. Your job is to [task]. Follow these guidelines:

**Focus Areas**
- ...

**Output Format**
- ...
```

The `description` field is critical — Kiro uses it to decide when to activate the agent. Be specific about when to use it.

**Skill:** Create a new folder in `.kiro/skills/<skill-name>/` with a `SKILL.md` file:

```markdown
---
name: skill-name
description: "What this skill does. Use when [specific scenarios]."
---

## Steps

1. **Step name** — What to do
2. **Step name** — What to do

## Expected Output

What the user gets when the skill completes.
```

**MCP server:** Add a new entry to `.kiro/mcp.json`:

```json
{
  "mcpServers": {
    "your-server": {
      "command": "npx",
      "args": ["-y", "@scope/mcp-server-package"],
      "env": {
        "API_KEY": "${YOUR_API_KEY}"
      }
    }
  }
}
```

### Modifying a Configuration

Open the file, edit the content, save. Kiro picks up changes automatically — no restart needed. Each file contains inline comments or clear structure that explains what each section does.

### Removing a Configuration

Delete the file (or remove the MCP server entry from `mcp.json`). Kiro stops applying it immediately.

### File Format Reference

| Config Type | File Extension | Location | Key Fields |
|-------------|---------------|----------|------------|
| Steering | `.md` | `.kiro/steering/` | `<!-- Scope: Global -->`, `## Rules`, `### Category` |
| Hook | `.md` | `.kiro/hooks/` | Trigger, Conditions, Action sections |
| Agent | `.md` | `.kiro/agents/` | YAML frontmatter: `description`, `tools` |
| Skill | `SKILL.md` | `.kiro/skills/<name>/` | YAML frontmatter: `name`, `description` |
| MCP | `.json` | `.kiro/mcp.json` | `mcpServers.<name>.command`, `.args`, `.env` |

---

## Recommended Powers

Powers are installed from the Kiro IDE Powers panel. Here are some that pair well with this starter kit:

| Power | Provider | What It Adds |
|-------|----------|--------------|
| Build AWS infrastructure with CDK and CloudFormation | AWS | CDK best practices, CloudFormation validation, security compliance checks |
| Deploy infrastructure with Terraform | HashiCorp | Terraform workflows, registry access, HCP integration |
| API Testing with Postman | Postman | Automated API testing, collection management |
| Snyk Secure at Inception | Snyk | Real-time security scanning and remediation |
| Datadog Observability | Datadog | Production debugging, metrics, traces, and logs |
| AWS Observability | AWS | CloudWatch, Application Signals, CloudTrail auditing |
| Design to Code with Figma | Figma | Implement designs as production-ready code |
| Build a backend with Supabase | Supabase | Postgres, auth, storage, and real-time subscriptions |

Browse all powers at [kiro.dev/powers](https://kiro.dev/powers/).

---

## Environment Variables

The MCP server configurations in `.kiro/mcp.json` use placeholder syntax. Set these environment variables before using the corresponding servers:

| Variable | Server | Description | How to Get It |
|----------|--------|-------------|---------------|
| `ALLOWED_DIRECTORIES` | filesystem | Comma-separated paths the filesystem server can access | Set to your project root, e.g., `/home/user/projects` |
| `POSTGRES_CONNECTION_STRING` | postgres | Full PostgreSQL connection URI | Format: `postgresql://user:password@host:5432/dbname` |
| `BRAVE_API_KEY` | brave-search | API key for Brave Search | Sign up at [brave.com/search/api](https://brave.com/search/api/) |
| `GITHUB_TOKEN` | github | GitHub personal access token | Create at [github.com/settings/tokens](https://github.com/settings/tokens) with `repo` and `read:org` scopes |

You can set these in your shell profile (`~/.bashrc`, `~/.zshrc`) or in a `.env` file that is excluded from version control (already in `.gitignore`).

---

## Validation

The repository includes a `validate.sh` script that checks the structural integrity of all configuration files:

```bash
chmod +x validate.sh
./validate.sh
```

The script verifies:
- All required directories exist
- File counts match expectations (6 steering, 6 hooks, 12 agents, 10 skills)
- `mcp.json` is valid JSON with 3-4 server entries
- README contains all required sections
- Each steering file contains its expected section headings
- Each hook file contains inline comments
- Each agent file has YAML frontmatter
- Each skill file has YAML frontmatter

---

## FAQ

**Can I use this with the Kiro CLI instead of the IDE?**
Yes, but with caveats. Steering files and MCP configs work the same way. Agent files need to be converted to JSON format for the CLI — see the [CLI agent docs](https://kiro.dev/docs/cli/custom-agents/configuration-reference/). Skills follow the same `SKILL.md` format in both.

**Do I need all of these files?**
No. Delete anything you don't need. Each file is independent. A minimal setup might be just a couple of steering files and a few agents.

**Will these configurations conflict with my existing Kiro setup?**
Workspace-level configurations (in `.kiro/`) take precedence over global configurations (in `~/.kiro/`). If you have global steering files, the workspace ones will override them when names collide.

**How do I share custom agents or skills with my team?**
Commit the `.kiro/` directory to your project repository. Everyone who clones the repo gets the same configurations automatically.

**Can I use this as a template for new projects?**
That's exactly what it's for. Fork or clone it, delete the configs you don't need, customize the rest, and start building.

**How do I update when new configurations are added upstream?**
If you forked the repo, pull from upstream. If you cloned it, cherry-pick the files you want. Each file is independent, so merging is straightforward.

---

## Contributing

Contributions are welcome. Here's how to get involved:

1. **Fork** the repository and create a feature branch.
2. **Follow existing patterns** — match the structure and style of existing configuration files.
3. **Test your changes** — run `./validate.sh` to verify the repository structure is intact.
4. **Submit a pull request** with a clear description of what you added or changed and why.

**Contribution ideas:**
- New steering files for additional domains (accessibility, performance, i18n, API design)
- Hooks for other development workflows (PR creation, branch naming, changelog updates)
- Agents for specialized roles (data engineer, mobile developer, DevSecOps)
- Skills for common tasks not yet covered (GraphQL schema generation, Docker Compose setup, Kubernetes manifests)
- MCP server configurations for popular tools

Please open an issue first if you'd like to discuss a larger change.

---

## License

This project is licensed under the [MIT License](LICENSE).
