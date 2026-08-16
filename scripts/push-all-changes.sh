#!/bin/bash
#
# Push All Changes to GitHub
#

PARENT_DIR="/home/sfloess/Development/github/FlossWare"

echo "========================================"
echo "Push All Changes to GitHub"
echo "========================================"
echo

for project in "$PARENT_DIR"/*-java "$PARENT_DIR"/build-tools; do
    if [[ ! -d "$project/.git" ]]; then
        continue
    fi

    project_name=$(basename "$project")
    echo "📦 $project_name"
    cd "$project"

    # Check if there are unpushed commits
    unpushed=$(git log @{u}.. --oneline 2>/dev/null | wc -l)

    if [[ $unpushed -gt 0 ]]; then
        echo "   Found $unpushed unpushed commit(s)"
        if git push; then
            echo "   ✅ Pushed"
        else
            echo "   ❌ Push failed"
        fi
    else
        echo "   ✓ Already up to date"
    fi

    echo
done

echo "========================================"
echo "Complete"
echo "========================================"
