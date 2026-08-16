#!/bin/bash
#
# Commit and Push Quality Gate Workflows to All Projects
#
# Usage:
#   ./commit-workflows-all.sh --all
#   ./commit-workflows-all.sh --project ../jcommons
#   ./commit-workflows-all.sh --all --dry-run
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
DRY_RUN=false
TARGET_PROJECT=""
APPLY_ALL=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            APPLY_ALL=true
            shift
            ;;
        --project)
            TARGET_PROJECT="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--all | --project <path>] [--dry-run]"
            exit 1
            ;;
    esac
done

if [[ "$APPLY_ALL" == false && -z "$TARGET_PROJECT" ]]; then
    echo "Error: Must specify --all or --project <path>"
    exit 1
fi

echo "========================================"
echo "Commit and Push Quality Gate Workflows"
echo "========================================"
echo "Dry Run: $DRY_RUN"
echo

commit_and_push() {
    local project_dir="$1"
    local project_name=$(basename "$project_dir")

    echo "📦 Processing: $project_name"

    # Check if .github directory exists
    if [[ ! -d "$project_dir/.github" ]]; then
        echo "   ⚠️  SKIPPED - No .github directory found"
        echo
        return
    fi

    # Check if workflow file exists
    if [[ ! -f "$project_dir/.github/workflows/quality-gate.yml" ]]; then
        echo "   ⚠️  SKIPPED - No quality-gate.yml found"
        echo
        return
    fi

    cd "$project_dir"

    # Check if git repo
    if [[ ! -d ".git" ]]; then
        echo "   ⚠️  SKIPPED - Not a git repository"
        echo
        return
    fi

    # Check if changes exist
    if ! git status --porcelain | grep -q ".github/"; then
        echo "   ℹ️  SKIPPED - No changes to commit"
        echo
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo "   ℹ️  Would commit and push .github/ (dry run)"
        git status --short .github/
        echo
        return
    fi

    # Add .github directory
    git add .github/

    # Commit
    git commit -m "$(cat <<'EOF'
Add automated quality gate workflow

Enables automated quality monitoring with GitHub Actions:
- Auto-creates issues when quality checks fail
- Comments quality metrics on PRs
- Daily security scans (2 AM UTC)
- Prevents merging failing PRs

Quality Gates:
- JaCoCo: ≥93% instruction, ≥86% branch coverage
- SpotBugs: 0 bugs
- PMD: 0 violations
- Checkstyle: 0 errors
- OWASP: 0 critical/high vulnerabilities

Issues auto-labeled: quality-gate, automated, [tool-specific]

See .github/README.md for details.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"

    # Push
    if git push; then
        echo "   ✅ Committed and pushed"
    else
        echo "   ❌ Failed to push (check permissions/remote)"
    fi

    echo
}

# Find and process projects
if [[ "$APPLY_ALL" == true ]]; then
    echo "Searching for projects with .github/ in: $PARENT_DIR"
    echo

    find "$PARENT_DIR" -maxdepth 2 -type d -name ".github" | while read -r github_dir; do
        project_dir="$(dirname "$github_dir")"

        # Skip build-tools itself
        if [[ "$project_dir" == "$SCRIPT_DIR" ]]; then
            continue
        fi

        commit_and_push "$project_dir"
    done
else
    # Apply to specific project
    if [[ ! -d "$TARGET_PROJECT" ]]; then
        echo "Error: Directory not found: $TARGET_PROJECT"
        exit 1
    fi

    commit_and_push "$TARGET_PROJECT"
fi

echo "========================================"
echo "Summary"
echo "========================================"
if [[ "$DRY_RUN" == true ]]; then
    echo "Dry run complete. No changes made."
else
    echo "Quality gate workflows committed and pushed!"
    echo
    echo "✅ Next Steps:"
    echo "  1. Check GitHub Actions tab in each repo"
    echo "  2. Workflow runs on next code push"
    echo "  3. Monitor for auto-created issues (quality-gate label)"
    echo
    echo "📊 Monitor Quality:"
    echo "  - GitHub → Actions tab (see workflow runs)"
    echo "  - GitHub → Issues → Labels → quality-gate"
    echo "  - PRs will have quality metric comments"
fi
echo
