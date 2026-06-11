# FlossWare Project Templates

Standardized quality tool configurations for Python, Java, and Bash projects.

## Version Standard

**All FlossWare projects use X.Y versioning** (not X.Y.Z):
- ✅ Examples: `0.1`, `1.0`, `1.1`, `2.0`
- ❌ Not: `0.1.0`, `1.0.0`, `2.0.0`

This applies to:
- Python `pyproject.toml`: `version = "0.1"`
- Java `pom.xml`: `<version>1.0</version>`
- Bash scripts: `VERSION="1.0"`

**Rationale:**
- Simpler version management
- Fully supported by PyPI, Maven, and package managers
- Consistent across all FlossWare projects
- The build-tools project itself uses 2.0

## Available Templates

### Python (`python/`)
Modern Python quality tools with comprehensive CI/CD:
- **Coverage**: 85% target, 80% minimum
- **Tools**: ruff, black, mypy, bandit, pytest
- **Python**: 3.9-3.13 support
- See `python/README.md` for details

### Java (`java/`)
Maven-based Java quality standards:
- **Coverage**: JaCoCo 80% line, 70% branch
- **Tools**: CheckStyle, SpotBugs, PMD, JUnit 5
- **Java**: 11, 17, 21 support
- See `java/README.md` for details

### Bash (`bash/`)
Shell script testing and quality:
- **Coverage**: kcov 70%+
- **Tools**: ShellCheck, shfmt, Bats
- **Testing**: Comprehensive Bats framework
- See `bash/README.md` for details

## Quick Start

1. Copy relevant template directory to your project
2. Replace placeholders:
   - `{{PROJECT_NAME}}` → your project name
   - `{{PACKAGE_NAME}}` → your package name
   - `{{VERSION}}` → X.Y version (e.g., "0.1", "1.0")
   - `{{GROUP_ID}}` → Maven group (Java only)
   - `{{ARTIFACT_ID}}` → Maven artifact (Java only)
3. Review and customize for your project
4. Commit and enable CI/CD

## Generation

These templates were generated from the curses-themes project using multi-agent workflows:
- Workflow 1 (wq6j0dvnt): Python quality tools (5 agents, 130k tokens)
- Workflow 2 (ww0gvlxum): Build-tools templates (6 agents, 193k tokens)
- Workflow 3 (w13x7jt1q): Documentation review (12 agents)

Source: https://github.com/FlossWare/curses-themes
