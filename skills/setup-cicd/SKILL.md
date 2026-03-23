---
name: setup-cicd
description: "Set up a CI/CD pipeline configuration with build, test, and deploy stages. Use when adding continuous integration or deployment to a project."
---

## Description

Generates a complete CI/CD pipeline configuration for a given project. The output includes provider-specific pipeline syntax with stages for building, testing, and deploying the application. Secrets are referenced through the provider's native secret management rather than hardcoded. The generated configuration follows best practices for caching, artifact handling, and environment separation.

When invoked, you'll need: the CI/CD platform (e.g., `github-actions`, `gitlab-ci`, `circleci`, `jenkins`, `aws-codepipeline`), the programming language (e.g., `typescript`, `python`, `java`, `go`), and the deployment target (e.g., `aws-ecs`, `aws-lambda`, `kubernetes`, `s3-cloudfront`, `heroku`). Optionally specify the branch strategy (default: `main`), package manager, and runtime version.

## Steps

1. **Generate pipeline config file** — Create the provider-specific configuration file in the expected location:
   - GitHub Actions → `.github/workflows/ci-cd.yml`
   - GitLab CI → `.gitlab-ci.yml`
   - CircleCI → `.circleci/config.yml`
   - Jenkins → `Jenkinsfile`
   - AWS CodePipeline → `buildspec.yml` and pipeline definition
   - Add a top-level comment block describing the pipeline purpose and trigger conditions

2. **Add build stage** — Configure the build step for the chosen language and package manager:
   - Check out the repository source code
   - Set up the language runtime at the specified version
   - Install dependencies using the project's package manager
   - Enable dependency caching to speed up subsequent runs (e.g., `~/.npm`, `.m2/repository`, `__pycache__`)
   - Compile or transpile the source code if the language requires a build step
   - Upload build artifacts for use in later stages

3. **Add test stage** — Configure the test step to run after a successful build:
   - Run the project's unit test suite with the appropriate test runner
   - Run linting and static analysis checks
   - Generate and upload a test coverage report as a pipeline artifact
   - Fail the pipeline if any test fails or coverage drops below a configurable threshold

4. **Add deploy stage** — Configure the deployment step for the chosen deployment target:
   - Gate deployment on successful completion of both build and test stages
   - Configure environment-specific deployments (e.g., `staging` on `develop` branch, `production` on `main`)
   - Add deployment commands specific to the target platform:
     - AWS ECS → build and push Docker image, update ECS service
     - AWS Lambda → package and deploy function code
     - Kubernetes → apply manifests with `kubectl` or Helm
     - S3 + CloudFront → sync build output to S3, invalidate CloudFront cache
   - Add a post-deploy health check or smoke test step to verify the deployment succeeded

5. **Configure secrets and environment variables** — Wire up secret references using the provider's native mechanism:
   - Reference deployment credentials through the provider's secret store (e.g., GitHub Secrets, GitLab CI Variables, AWS Secrets Manager)
   - Add placeholder entries for required secrets (e.g., `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `DOCKER_REGISTRY_TOKEN`)
   - Never hardcode secret values in the pipeline file — use `${{ secrets.NAME }}` or equivalent syntax
   - Add inline comments listing which secrets must be configured in the provider's UI before the pipeline runs

## Expected Output

A ready-to-use CI/CD pipeline configuration file in the correct location for the chosen provider. The pipeline includes build, test, and deploy stages with dependency caching, artifact handling, secret references, and environment-specific deployment logic. After configuring the required secrets in the CI provider's settings, the pipeline runs end-to-end on the next push to the configured branch.

## Notes

- The generated pipeline assumes a single deployable artifact. For monorepo setups, add path-based filters or matrix builds to target individual packages.
- Secrets must be configured manually in the CI provider's UI or API before the pipeline can deploy. The generated file includes comments listing every required secret.
- The deploy stage uses a simple rolling deployment strategy by default. For blue-green or canary deployments, extend the deploy step with provider-specific configuration.
- Caching paths are set to common defaults for each language. Adjust them if your project uses a non-standard dependency directory.
- Add notification steps (Slack, email, PagerDuty) after the deploy stage to alert the team on success or failure.
- For pull request workflows, consider adding a separate job that runs build and test without deploying, triggered on PR events.