#!/bin/bash
#
# Fix Failed Workflow Pushes
#
# Handles projects that failed to push due to remote conflicts
#

set -e

FAILED_PROJECTS=(
    "gofl"
    "jcollections"
    "jcloudstorage"
    "jfiletransfer"
    "jcontainer"
    "jvcs"
)

PARENT_DIR="/home/sfloess/Development/github/FlossWare"

echo "========================================"
echo "Fix Failed Workflow Pushes"
echo "========================================"
echo "Projects to fix: ${#FAILED_PROJECTS[@]}"
echo

fix_project() {
    local project_name="$1"
    local project_dir="$PARENT_DIR/$project_name"

    echo "📦 Fixing: $project_name"

    if [[ ! -d "$project_dir" ]]; then
        echo "   ❌ Directory not found: $project_dir"
        echo
        return
    fi

    cd "$project_dir"

    # Check if .github changes are committed
    if ! git log -1 --oneline | grep -q "automated quality gate"; then
        echo "   ⚠️  No quality gate commit found - skipping"
        echo
        return
    fi

    # Pull with rebase to integrate remote changes
    echo "   🔄 Pulling with rebase..."
    if git pull --rebase; then
        echo "   ✅ Pulled successfully"
    else
        echo "   ⚠️  Rebase conflicts - manual resolution needed"
        echo "   💡 Run: cd $project_dir && git rebase --abort"
        echo
        return
    fi

    # Push
    echo "   📤 Pushing..."
    if git push; then
        echo "   ✅ Successfully pushed!"
    else
        # Try setting upstream if on non-main branch
        current_branch=$(git branch --show-current)
        if [[ "$current_branch" != "main" ]]; then
            echo "   🔄 Setting upstream for branch: $current_branch"
            if git push --set-upstream origin "$current_branch"; then
                echo "   ✅ Successfully pushed with upstream!"
            else
                echo "   ❌ Failed to push - check manually"
            fi
        else
            echo "   ❌ Failed to push - check manually"
        fi
    fi

    echo
}

for project in "${FAILED_PROJECTS[@]}"; do
    fix_project "$project"
done

echo "========================================"
echo "Summary"
echo "========================================"
echo "Fixed projects. Check output above for any remaining failures."
echo
echo "For manual fixes:"
echo "  cd /path/to/project"
echo "  git pull --rebase"
echo "  git push"
echo
