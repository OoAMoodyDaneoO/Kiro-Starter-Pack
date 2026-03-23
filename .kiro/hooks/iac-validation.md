# Hook: IaC Validation

<!-- Trigger: on-save — activates whenever an infrastructure-as-code file is saved -->
<!-- Description: Validates IaC template syntax and checks for best-practice violations -->

## Description

<!-- This hook watches for file save events on infrastructure-as-code files
     (CloudFormation, Terraform, CDK, SAM) and instructs Kiro to validate the
     template for syntax errors, structural issues, and best-practice violations.
     It catches misconfigurations at authoring time, before they reach deployment. -->

This hook fires whenever an infrastructure-as-code file is saved. Kiro parses the saved
template to verify it is syntactically valid, then checks it against a set of best-practice
rules covering security, tagging, encryption, and least-privilege access. If any issues are
found, Kiro reports them inline with severity levels and suggested fixes so the developer
can resolve problems before committing or deploying.

## Trigger

<!-- The event type that activates this hook. "on-save" means it runs each time
     the user saves a file that matches the conditions below. -->
- **Event**: file saved (on-save)

<!-- Conditions filter which saved files actually trigger the action. Only IaC
     template files should fire this hook — application source code, tests, and
     other configs are excluded to avoid unnecessary validation passes. -->
- **Conditions**:
  - Only CloudFormation templates: `*.template.json`, `*.template.yaml`, `template.json`, `template.yaml`, `*.cfn.json`, `*.cfn.yaml`
  - Only Terraform files: `*.tf`, `*.tfvars`
  - Only AWS CDK infrastructure files: files in `lib/`, `infra/`, or `cdk/` directories matching `*.ts`, `*.py`, `*.java`, `*.go` that contain CDK constructs
  - Only SAM templates: `template.yaml`, `template.yml`, `sam.yaml`, `sam.yml` with `Transform: AWS::Serverless`
  - Exclude generated files: skip `cdk.out/`, `.terraform/`, `terraform.tfstate*`, `node_modules/`, `dist/`
  - Exclude lock files: skip `.terraform.lock.hcl`

## Action

<!-- Detailed description of what Kiro does when the hook fires. The action runs
     automatically after the trigger conditions are met. -->

When a matching IaC file is saved, Kiro performs the following:

1. **Detect template type** — Identify whether the file is a CloudFormation template,
   Terraform configuration, CDK construct, or SAM template based on file extension,
   directory context, and file content markers (e.g., `AWSTemplateFormatVersion`,
   `resource` blocks, CDK imports).
2. **Validate syntax** — Parse the template to check for syntax errors: valid JSON or
   YAML structure for CloudFormation/SAM, valid HCL for Terraform, valid language syntax
   for CDK files. Report any parse errors with line numbers.
3. **Check resource configuration** — Verify that defined resources follow best practices:
   - Encryption at rest is enabled for data stores (S3, EBS, RDS, DynamoDB)
   - Encryption in transit is enforced (HTTPS-only listeners, TLS policies)
   - Security groups do not allow unrestricted ingress (`0.0.0.0/0` on sensitive ports)
   - IAM policies follow least-privilege (no `Action: "*"` or `Resource: "*"`)
4. **Verify tagging** — Check that all taggable resources include required tags:
   `Environment`, `Owner`, and `CostCenter`. Flag resources missing any of these tags.
5. **Check logging and monitoring** — Verify that logging is enabled where applicable:
   S3 access logging, CloudTrail, VPC Flow Logs, ALB access logs, and API Gateway
   execution logging.
6. **Report findings** — Present a structured summary grouped by severity (critical,
   high, medium, informational). Each finding includes the resource logical name, the
   issue description, and a suggested remediation. If no issues are found, confirm the
   template passed all checks.

## Configuration

<!-- Inline comments explaining configurable parameters. Users can adjust these
     values to match their project's IaC tooling and compliance requirements. -->

<!-- template_patterns: Glob patterns for IaC files that trigger this hook.
     Add or remove patterns to match your project's IaC tooling and conventions. -->
<!-- severity_threshold: The minimum severity that triggers an inline warning.
     "critical" only shows critical issues; "high" shows high and above;
     "medium" includes medium severity. Default: "medium". -->
<!-- required_tags: List of tag keys that must be present on all taggable resources.
     Default: ["Environment", "Owner", "CostCenter"]. Customize to match your
     organization's tagging policy. -->
<!-- check_encryption: Whether to verify encryption-at-rest and encryption-in-transit
     settings on applicable resources. Default: true. -->
<!-- check_iam_least_privilege: Whether to flag overly permissive IAM policies
     (wildcard actions or resources). Default: true. -->
<!-- allowed_ingress_cidrs: CIDR ranges allowed for security group ingress rules.
     Use to permit known office or VPN ranges. Default: [] (flags all 0.0.0.0/0 rules). -->
<!-- ignore_rules: List of rule IDs to suppress for known exceptions.
     Use this for accepted risks that have been reviewed and documented.
     Example: ["encryption-at-rest", "required-tags"] -->
