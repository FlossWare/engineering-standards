#!/bin/bash
#
# Force Push Remaining Projects (Resolve Conflicts)
#

PROJECTS=(
    "collections-java"
    "cloudstorage-java"
    "container-java"
    "eventbus-java"
    "filetransfer-java"
    "fs-watcher-java"
    "remote-java"
    "threadpool-java"
    "vcs-java"
)

PARENT_DIR="/home/sfloess/Development/github/FlossWare"

echo "========================================"
echo "Force Push Remaining Projects"
echo "========================================"
echo

for project in "${PROJECTS[@]}"; do
    echo "📦 $project"
    cd "$PARENT_DIR/$project"

    # Abort any in-progress rebase
    git rebase --abort 2>/dev/null || true

    # Force push (our renamed code is correct)
    if git push --force; then
        echo "   ✅ Force pushed"
    else
        echo "   ❌ Force push failed"
    fi

    echo
done

echo "========================================"
echo "Complete"
echo "========================================"
