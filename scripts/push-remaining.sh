#!/bin/bash
#
# Push Remaining Projects with Pull/Rebase
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
echo "Push Remaining Projects"
echo "========================================"
echo

for project in "${PROJECTS[@]}"; do
    echo "📦 $project"
    cd "$PARENT_DIR/$project"

    # Pull with rebase
    if git pull --rebase; then
        echo "   ✅ Pulled"
    else
        echo "   ❌ Pull failed - skipping"
        echo
        continue
    fi

    # Push
    if git push; then
        echo "   ✅ Pushed"
    else
        echo "   ❌ Push failed"
    fi

    echo
done

echo "========================================"
echo "Complete"
echo "========================================"
