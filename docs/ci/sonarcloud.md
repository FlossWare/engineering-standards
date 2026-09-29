# SonarCloud CI

FlossWare repositories that use GitHub Actions SHOULD consume the shared SonarCloud quality-gate workflow rather than maintaining repository-specific scanner plumbing.

## Reusable workflow

The canonical workflow is:

`.github/workflows/sonarcloud-quality-gate.yml`

It is invoked with `workflow_call` and requires:

- `project_key`: the repository's SonarCloud project key.
- `SONAR_TOKEN`: a repository or organization secret.
- `organization`: defaults to `flossware`.

The workflow performs a full checkout and runs the SonarCloud scanner with the quality gate configured to wait for its result.

## Node.js example

A Node.js repository can keep its language-specific test and lint jobs in its normal CI workflow and invoke the shared quality gate separately:

```yaml
jobs:
  sonar:
    uses: FlossWare/engineering-standards/.github/workflows/sonarcloud-quality-gate.yml@main
    with:
      project_key: FlossWare_example-repo
    secrets:
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

If coverage is generated, pass the appropriate scanner property through `extra_args`, for example:

```yaml
with:
  project_key: FlossWare_example-repo
  extra_args: >-
    -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
```

Language-specific build, test, lint, and coverage generation remain the responsibility of the consuming repository. The shared workflow owns SonarCloud authentication, scanner invocation, and quality-gate enforcement.

## CI expectations

A SonarCloud workflow SHALL:

1. Authenticate using `SONAR_TOKEN`.
2. Analyze the repository source from a full checkout.
3. Use the FlossWare SonarCloud organization unless explicitly overridden.
4. Wait for the quality-gate result.
5. Fail the workflow when the quality gate fails.

Repositories SHOULD treat a failed quality gate as a CI defect and resolve the reported finding rather than weakening or bypassing the gate.
