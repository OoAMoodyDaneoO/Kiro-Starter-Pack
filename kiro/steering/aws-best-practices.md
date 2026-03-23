# AWS Cloud Best Practices

<!-- Scope: Global -->
<!-- Description: Enforce secure, cost-effective, and well-architected AWS cloud infrastructure across all projects -->

## Overview

These standards define the AWS cloud best practices that Kiro enforces during infrastructure code generation and review. All rules apply to any AWS service or resource definition regardless of the provisioning tool (CloudFormation, Terraform, CDK, SAM, or console-generated templates). The goal is to ensure every AWS deployment follows the Well-Architected Framework principles for security, reliability, and cost optimization.

## Rules

### IAM Policies

- **Least-privilege access — Scope permissions to specific actions and resources**: Every IAM policy must grant only the minimum permissions required for the task. Never use `"Action": "*"` or `"Resource": "*"` in production policies. Specify exact actions (e.g., `s3:GetObject`) and narrow resources to specific ARNs.
- **No inline policies — Use managed or customer-managed policies**: Prefer AWS managed policies or customer-managed policies attached to roles over inline policies embedded directly on users or roles. Managed policies are reusable, auditable, and easier to update across multiple principals.
- **Avoid long-lived credentials — Use IAM roles and temporary credentials**: Do not create IAM access keys for applications running on AWS. Use IAM roles with temporary credentials via STS for EC2 instances, Lambda functions, ECS tasks, and other AWS compute services. Rotate any unavoidable access keys on a regular schedule.
- **Enforce MFA — Require multi-factor authentication for privileged actions**: Require MFA for all IAM users with console access and for sensitive API operations. Use IAM policy conditions (`aws:MultiFactorAuthPresent`) to enforce MFA on privileged actions such as deleting resources or modifying IAM policies.
- **Separate duties — Use distinct roles for distinct responsibilities**: Create separate IAM roles for different workloads and environments. A deployment pipeline role should not have the same permissions as an application runtime role. Use permission boundaries to cap the maximum permissions a role can have.

### Resource Tagging

- **Environment tag — Label every resource with its deployment stage**: Every taggable AWS resource must include an `Environment` tag with a value such as `production`, `staging`, `development`, or `sandbox`. This enables filtering by environment in cost reports, access policies, and operational dashboards.
- **Owner tag — Identify the responsible team or individual**: Every taggable resource must include an `Owner` tag specifying the team, service, or individual responsible for the resource. This ensures accountability and makes it straightforward to contact the right people during incidents or cost reviews.
- **Cost-center tag — Enable financial attribution**: Every taggable resource must include a `CostCenter` tag that maps the resource to a billing code or business unit. This enables accurate cost allocation, chargeback reporting, and budget tracking across organizational units.
- **Enforce tagging at creation — Use tag policies and SCPs**: Use AWS Organizations tag policies or Service Control Policies to enforce required tags at resource creation time. Resources missing mandatory tags should be prevented from launching or flagged immediately for remediation.
- **Consistent naming scheme — Standardize tag keys and allowed values**: Define a documented tagging convention with exact key names (e.g., `Environment`, not `env` or `Env`) and an enumerated set of allowed values. Inconsistent tag keys defeat the purpose of tagging by fragmenting reports and queries.

### Encryption

- **Encryption at rest — Enable for all data stores**: All data stores must have encryption at rest enabled. This includes S3 buckets (SSE-S3, SSE-KMS, or SSE-C), EBS volumes, RDS instances, DynamoDB tables, EFS file systems, and any other service that stores persistent data. Use AWS KMS customer-managed keys for sensitive workloads.
- **Encryption in transit — Enforce TLS for all communication**: All network communication must use TLS 1.2 or higher. Enforce HTTPS-only access on S3 buckets, API Gateway endpoints, and load balancers. Use `aws:SecureTransport` conditions in S3 bucket policies to deny unencrypted requests.
- **KMS key management — Use customer-managed keys for sensitive data**: For workloads handling sensitive or regulated data, use AWS KMS customer-managed keys (CMKs) rather than AWS-managed keys. Define key rotation policies, restrict key usage via key policies, and audit key access through CloudTrail.
- **No unencrypted secrets — Never store plaintext secrets in templates or code**: Never embed passwords, API keys, or connection strings in plaintext within CloudFormation templates, Terraform files, or application code. Use AWS Secrets Manager, SSM Parameter Store (SecureString), or environment variable references with encrypted backing stores.
- **Enforce encryption by default — Use SCPs and config rules**: Use Service Control Policies or AWS Config rules to prevent the creation of unencrypted resources. For example, deny `s3:CreateBucket` unless server-side encryption is configured, or deny `ec2:RunInstances` with unencrypted EBS volumes.

### Logging and Monitoring

- **CloudTrail — Enable across all regions and accounts**: AWS CloudTrail must be enabled in every region and every account in the organization. Configure a centralized trail that logs management events and data events for critical services (S3, Lambda, DynamoDB). Store trail logs in a dedicated, access-restricted S3 bucket with integrity validation enabled.
- **CloudWatch alarms — Monitor key operational metrics**: Set up CloudWatch alarms for critical metrics on every deployed service: CPU utilization, memory usage, error rates, latency percentiles, and queue depths. Every alarm must have an associated notification action (SNS topic, PagerDuty, or equivalent) so that threshold breaches are surfaced immediately.
- **Centralized logging — Aggregate logs for analysis**: Route application logs, access logs, and infrastructure logs to a centralized logging solution (CloudWatch Logs, OpenSearch, or a third-party SIEM). Use structured log formats (JSON) with consistent fields (timestamp, request ID, severity) to enable efficient querying and correlation.
- **VPC Flow Logs — Capture network traffic metadata**: Enable VPC Flow Logs on all VPCs and subnets to capture accepted and rejected traffic metadata. Store flow logs in CloudWatch Logs or S3 for security analysis, troubleshooting, and compliance auditing.
- **Alerting on security events — Detect anomalies and unauthorized access**: Configure alerts for security-relevant events: root account usage, IAM policy changes, security group modifications, unauthorized API calls, and console sign-in failures. Use CloudTrail with EventBridge rules or GuardDuty findings to trigger automated notifications.

### Infrastructure-as-Code

- **Version-controlled templates — Define all resources in code**: Every AWS resource must be defined in version-controlled infrastructure-as-code templates (CloudFormation, Terraform, CDK, or SAM). No production resource should be created or modified manually through the AWS console. All changes go through code review and a deployment pipeline.
- **No manual console changes — Enforce IaC-only provisioning**: Treat the AWS console as read-only for production environments. Use SCPs or IAM policies to restrict direct resource creation in production accounts. All infrastructure changes must originate from committed, reviewed IaC templates deployed through an automated pipeline.
- **Parameterize environments — Use variables for environment-specific values**: Templates must use parameters or variables for values that differ across environments (instance sizes, domain names, VPC CIDRs, account IDs). Never hardcode environment-specific values. Use separate parameter files or environment-specific configuration for each deployment stage.
- **State management — Protect and back up IaC state**: For tools that maintain state files (Terraform), store state in a remote backend (S3 + DynamoDB locking) with encryption, versioning, and restricted access. Never commit state files to version control. For CloudFormation, rely on the service-managed stack state and enable stack termination protection on production stacks.
- **Drift detection — Monitor for out-of-band changes**: Regularly run drift detection on deployed stacks and state files to identify resources that have been modified outside of the IaC pipeline. Use AWS Config rules, CloudFormation drift detection, or Terraform plan to catch and remediate drift before it causes inconsistencies.
