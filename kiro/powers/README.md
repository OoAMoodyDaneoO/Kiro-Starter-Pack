# Kiro Powers

Powers are installable packages that add specialized context and tools to Kiro agents on-demand. They are NOT manually created configuration files.

## Installing Powers

1. Open Kiro IDE → Powers panel
2. Browse curated powers from partners and the community
3. Click "Add to Kiro" to install

You can also install powers from GitHub repositories using "Add power from GitHub" in the IDE.

## Available Powers

Browse all available powers at [kiro.dev/powers](https://kiro.dev/powers/).

Popular powers include:
- **Build AWS infrastructure with CDK and CloudFormation** — AWS best practices and validation
- **Deploy infrastructure with Terraform** — HashiCorp Terraform workflows
- **API Testing with Postman** — Automate API testing and collection management
- **Snyk Secure at Inception** — Security scanning and remediation
- **Datadog Observability** — Production debugging and performance analysis

## Creating Your Own Power

To create a custom power, see the [official documentation](https://kiro.dev/docs/powers/create/).

A power is a GitHub repository containing:
- `POWER.md` — Metadata (name, description, keywords) and instructions
- `mcp.json` — Optional MCP server configuration
- `steering/` — Optional workflow-specific guidance files

## Example Power Structure

```
my-custom-power/
├── POWER.md          # Required: metadata + instructions
├── mcp.json          # Optional: MCP server config
└── steering/         # Optional: workflow guides
    ├── setup.md
    └── best-practices.md
```

See [github.com/kirodotdev/powers](https://github.com/kirodotdev/powers) for examples.