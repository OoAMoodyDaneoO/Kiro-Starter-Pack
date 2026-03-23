---
name: setup-monitoring
description: "Set up monitoring, health checks, alerting, and dashboards for a deployed service. Use when deploying a new service or adding observability."
---

## Description

Sets up monitoring and alerting for a deployed service. The output includes a monitoring configuration file with metric collection rules, health check endpoints and probes, alert definitions with severity levels and notification routing, and a dashboard template for visualizing key service metrics. The generated configuration follows observability best practices: monitor the four golden signals (latency, traffic, errors, saturation), alert on symptoms rather than causes, and keep dashboards focused on actionable data.

When invoked, you'll need: the service name, the cloud provider (`aws`, `gcp`, `azure`, `self-hosted`), and the alert notification channels (e.g., `slack`, `pagerduty`, `email`, `opsgenie`, `sns`). Optionally specify the service compute type (default: `ecs`), health endpoint path (default: `/health`), alert email, Slack webhook URL environment variable name, and dashboard tool (auto-detected from cloud provider).

## Steps

1. **Generate monitoring configuration** — Create the provider-specific monitoring config file:
   - AWS → CloudWatch metric filters, namespace, and dimensions in a CloudFormation or CDK snippet
   - GCP → Cloud Monitoring metric descriptors and uptime check config
   - Azure → Application Insights and Azure Monitor configuration
   - Self-hosted → Prometheus `prometheus.yml` scrape config and recording rules
   - Define metric collection for the four golden signals:
     - **Latency** — request duration percentiles (p50, p95, p99)
     - **Traffic** — request rate (requests per second)
     - **Errors** — error rate and error ratio (5xx / total)
     - **Saturation** — CPU utilization, memory usage, connection pool usage
   - Add service-specific labels and dimensions (`service`, `environment`, `region`)
   - Write the config to `monitoring/<service_name>/metrics-config.<ext>`

2. **Add health checks** — Configure health check probes for the service:
   - Generate an HTTP health check probe targeting the health endpoint with expected 200 response
   - Configure liveness and readiness probes (for Kubernetes) or target group health checks (for ECS/ALB)
   - Set check interval (30 seconds), timeout (5 seconds), and failure thresholds (3 consecutive failures)
   - Add a deep health check definition that verifies downstream dependencies (database, cache, external APIs)
   - Write health check config to `monitoring/<service_name>/health-checks.<ext>`

3. **Configure alerts** — Define alert rules with severity levels and notification routing:
   - **Critical alerts** (page immediately):
     - Service health check failing for more than 2 minutes
     - Error rate exceeding 5% of total requests over a 5-minute window
     - Service returning zero traffic for more than 3 minutes (possible outage)
   - **Warning alerts** (notify channel, no page):
     - P99 latency exceeding 2 seconds over a 10-minute window
     - CPU utilization above 80% for more than 10 minutes
     - Memory utilization above 85% for more than 10 minutes
   - **Info alerts** (log only):
     - Deployment detected (new version rolled out)
     - Scaling event triggered (auto-scaling up or down)
   - Route critical alerts to PagerDuty or on-call channel, warnings to Slack or email, info to a logging channel
   - Use `${VAR_NAME}` placeholder syntax for webhook URLs, API keys, and email addresses
   - Write alert definitions to `monitoring/<service_name>/alerts.<ext>`

4. **Add dashboard template** — Generate a dashboard definition for visualizing service metrics:
   - Create a dashboard with the service name as the title
   - Add panels for each golden signal:
     - **Request rate** — time series graph of requests per second
     - **Error rate** — time series graph with error percentage overlay
     - **Latency distribution** — heatmap or percentile graph (p50, p95, p99)
     - **Resource utilization** — CPU and memory gauges with threshold markers
   - Add a panel for recent alerts and their current status
   - Add a panel for health check status (up/down timeline)
   - Include template variables for environment and time range filtering
   - Write the dashboard to `monitoring/<service_name>/dashboard.<ext>` (JSON for Grafana/CloudWatch, HCL for Terraform-managed dashboards)

## Expected Output

A `monitoring/<service_name>/` directory containing four configuration files: a metrics collection config, health check definitions, alert rules with notification routing, and a dashboard template. After setting the required environment variables for notification channels and importing the dashboard into the monitoring platform, the service has end-to-end observability covering metrics, health checks, alerts, and visualization.

## Notes

- Alert thresholds are set to reasonable defaults. Tune them based on your service's baseline performance — run for a week, observe normal ranges, then adjust.
- The dashboard template is a starting point. Add business-specific panels (e.g., orders processed, messages consumed) after the initial setup.
- For AWS, the generated CloudWatch config pairs well with the `generate-iac` skill to embed monitoring directly in your infrastructure templates.
- Notification channel credentials (Slack webhooks, PagerDuty keys, SNS topic ARNs) must be configured as environment variables before alerts can fire. The generated config includes comments listing every required variable.
- For Kubernetes deployments, the health check probes are generated as pod spec snippets. Copy them into your deployment manifests or Helm values.
- Consider adding synthetic monitoring (external uptime checks from multiple regions) for public-facing services. This skill generates internal health checks only.
- The deep health check definition is a template — update the dependency list to match your service's actual downstream connections.