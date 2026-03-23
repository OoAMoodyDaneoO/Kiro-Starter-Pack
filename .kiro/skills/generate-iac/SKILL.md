---
name: generate-iac
description: "Generate infrastructure-as-code templates from a high-level architecture description. Use when turning architecture designs into deployable CloudFormation, Terraform, or CDK code."
---

## Description

Generates infrastructure-as-code templates from a high-level architecture description. The user describes the desired system architecture in plain language (e.g., "a REST API backed by Lambda functions with a DynamoDB table and an S3 bucket for uploads"), and this skill produces a complete IaC template with resource definitions, networking configuration, IAM roles and policies, and stack outputs. The generated template follows cloud best practices: least-privilege IAM, encryption at rest and in transit, resource tagging, and parameterized environment values.

When invoked, you'll need: a plain-language architecture description, the target cloud provider (`aws`, `gcp`, or `azure`), and the IaC tool (`cloudformation`, `terraform`, or `cdk`). Optionally specify the environment name (default: `development`), cloud region, project name, and CDK language (default: `typescript`).

## Steps

1. **Parse architecture description** — Analyze the plain-language architecture description to identify:
   - Compute resources (Lambda functions, ECS services, EC2 instances, containers)
   - Data stores (DynamoDB tables, RDS instances, S3 buckets, ElastiCache clusters)
   - Networking components (VPCs, subnets, load balancers, API gateways, CDNs)
   - Integration services (SQS queues, SNS topics, EventBridge rules, Step Functions)
   - Data flow and connectivity between components
   - Add an inline comment at the top of the template summarizing the parsed architecture

2. **Generate resource definitions** — Create IaC resource blocks for each identified component:
   - Define each resource with sensible defaults and best-practice configurations
   - Enable encryption at rest for all data stores (SSE for S3, encryption for RDS/DynamoDB)
   - Enable encryption in transit where applicable (TLS for load balancers, HTTPS-only for APIs)
   - Apply consistent resource tagging: `Environment`, `Project`, `ManagedBy` tags on every taggable resource
   - Use parameterized values for environment-specific settings (instance sizes, capacity, domain names)
   - Add an inline comment above each resource explaining its purpose and key configuration choices

3. **Add networking configuration** — Generate the networking layer connecting all components:
   - Create a VPC with public and private subnets across multiple availability zones (if the architecture requires one)
   - Configure security groups with least-privilege ingress and egress rules for each component
   - Set up route tables, internet gateways, and NAT gateways as needed
   - Configure load balancer listeners, target groups, and health checks
   - Place data stores in private subnets with no direct internet access
   - Add inline comments explaining each security group rule and routing decision

4. **Add IAM roles and policies** — Generate least-privilege IAM configuration for every component:
   - Create a dedicated IAM role for each compute resource (Lambda execution role, ECS task role, EC2 instance profile)
   - Scope each policy to the minimum required actions and specific resource ARNs — never use `*` for actions or resources
   - Add trust policies that restrict role assumption to the intended service principal
   - Create separate policies for read and write access where applicable
   - Add inline comments on each policy statement explaining what it permits and why

5. **Add outputs and cross-references** — Generate stack outputs and wire components together:
   - Export key resource identifiers (ARNs, endpoints, URLs, DNS names) as stack outputs
   - Wire resource references so components can discover each other (e.g., Lambda environment variable pointing to DynamoDB table name)
   - Add output descriptions explaining what each exported value is used for
   - Generate a summary comment block listing all outputs and their intended consumers
   - For Terraform, generate a `outputs.tf` file; for CloudFormation, add an `Outputs` section; for CDK, use `CfnOutput` constructs

## Expected Output

A complete IaC template (or set of files) ready for deployment. For CloudFormation, a single YAML template file. For Terraform, a set of `.tf` files organized by concern (`main.tf`, `variables.tf`, `outputs.tf`, `iam.tf`, `networking.tf`). For CDK, a stack class file in the chosen language with construct definitions. Every resource block includes inline comments explaining its purpose, configuration choices, and relationship to other components. The template is parameterized so it can be deployed to any environment by changing input variables.

## Notes

- The generated template is a starting point. Review IAM policies and security group rules before deploying to production — automated generation covers common patterns but may not capture every project-specific constraint.
- For complex architectures, consider running this skill multiple times for different layers (networking, compute, data) and composing the results using nested stacks or Terraform modules.
- The skill generates single-region infrastructure by default. For multi-region deployments, duplicate and adapt the generated template for each region, or add replication and failover resources manually.
- Resource sizing (instance types, capacity units, memory allocation) uses conservative defaults suitable for development. Scale up for staging and production by adjusting the parameterized values.
- Pair this skill with the `setup-monitoring` skill to add observability to the generated infrastructure immediately after provisioning.
- For CDK output, the generated code assumes a standard CDK project structure. Run `cdk init` first if you don't already have a CDK project, then drop the generated stack file into `lib/`.
- All sensitive values (database passwords, API keys) use `${VAR_NAME}` placeholder syntax or parameter store references — never hardcoded in the template.