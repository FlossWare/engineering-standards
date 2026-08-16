#!/bin/bash
#
# Rename All FlossWare j* Projects
#
# Renames: j{name} → {name}-java
# Packages: org.flossware.j{name} → org.flossware.{name}
# Version: All → 2.0 (breaking change)
#
# Usage:
#   ./rename-all-projects.sh --all
#   ./rename-all-projects.sh --project jcommons
#   ./rename-all-projects.sh --all --dry-run
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
DRY_RUN=false
TARGET_PROJECT=""
APPLY_ALL=false

# Project mapping: old_name:new_name:old_package:new_package
PROJECTS=(
    "jcommons:commons-java:jcommons:commons"
    "jcollections:collections-java:jcollections:collections"
    "jcurses:curses-java:jcurses:curses"
    "jclassloader:classloader-java:jclassloader:classloader"
    "jcloudstorage:cloudstorage-java:jcloudstorage:cloudstorage"
    "jcontainer:container-java:jcontainer:container"
    "jdiskwipe:diskwipe-java:jdiskwipe:diskwipe"
    "jencrypt:encrypt-java:jencrypt:encrypt"
    "jeventbus:eventbus-java:jeventbus:eventbus"
    "jfiletransfer:filetransfer-java:jfiletransfer:filetransfer"
    "jfs-watcher:fs-watcher-java:jfswatcher:fswatcher"
    "jmessaging:messaging-java:jmessaging:messaging"
    "jnexus:nexus-java:jnexus:nexus"
    "jplatform:platform-java:jplatform:platform"
    "jremote:remote-java:jremote:remote"
    "jresource-monitor:resource-monitor-java:jresourcemonitor:resourcemonitor"
    "jthreadpool:threadpool-java:jthreadpool:threadpool"
    "jvcs:vcs-java:jvcs:vcs"
    "build-tools:build-tools:jbuild-tools:build-tools-java"
)

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
            echo "Usage: $0 [--all | --project <old-name>] [--dry-run]"
            exit 1
            ;;
    esac
done

echo "========================================"
echo "FlossWare Project Rename"
echo "========================================"
echo "Dry Run: $DRY_RUN"
echo
echo "Changes:"
echo "  - Repository: j{name} → {name}-java"
echo "  - Package: org.flossware.j{name} → org.flossware.{name}"
echo "  - Version: * → 2.0"
echo "  - Artifact ID: j{name} → {name}-java"
echo

rename_project() {
    local mapping="$1"
    IFS=':' read -r old_name new_name old_pkg new_pkg <<< "$mapping"

    local old_dir="$PARENT_DIR/$old_name"
    local new_dir="$PARENT_DIR/$new_name"

    echo "📦 Processing: $old_name → $new_name"
    echo "   Package: org.flossware.$old_pkg → org.flossware.$new_pkg"

    # Check if old directory exists
    if [[ ! -d "$old_dir" ]]; then
        echo "   ⚠️  SKIPPED - Directory not found: $old_dir"
        echo
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo "   ℹ️  Would rename (dry run):"
        echo "      - GitHub repo: $old_name → $new_name"
        echo "      - Local dir: $old_name → $new_name"
        echo "      - Packages: org.flossware.$old_pkg → org.flossware.$new_pkg"
        echo "      - Version: → 2.0"
        echo
        return
    fi

    cd "$old_dir"

    # Step 1: Rename GitHub repository
    echo "   🔄 Renaming GitHub repository..."
    if gh api repos/FlossWare/$old_name -X PATCH -f name="$new_name" > /dev/null 2>&1; then
        echo "   ✅ GitHub repo renamed"
    else
        echo "   ⚠️  Failed to rename GitHub repo (may need manual rename)"
    fi

    # Step 2: Update git remote URL
    echo "   🔄 Updating git remote..."
    git remote set-url origin "https://github.com/FlossWare/$new_name.git"
    echo "   ✅ Git remote updated"

    # Step 3: Rename Java package directories
    echo "   🔄 Renaming package directories..."
    if [[ -d "src/main/java/org/flossware/$old_pkg" ]]; then
        mkdir -p "src/main/java/org/flossware/$new_pkg"
        mv src/main/java/org/flossware/$old_pkg/* src/main/java/org/flossware/$new_pkg/ 2>/dev/null || true
        rmdir "src/main/java/org/flossware/$old_pkg" 2>/dev/null || true
        echo "   ✅ Renamed src/main/java packages"
    fi

    if [[ -d "src/test/java/org/flossware/$old_pkg" ]]; then
        mkdir -p "src/test/java/org/flossware/$new_pkg"
        mv src/test/java/org/flossware/$old_pkg/* src/test/java/org/flossware/$new_pkg/ 2>/dev/null || true
        rmdir "src/test/java/org/flossware/$old_pkg" 2>/dev/null || true
        echo "   ✅ Renamed src/test/java packages"
    fi

    # Step 4: Update package declarations in all Java files
    echo "   🔄 Updating package declarations..."
    find src -name "*.java" -type f -exec sed -i "s/package org\.flossware\.$old_pkg/package org.flossware.$new_pkg/g" {} \;
    echo "   ✅ Updated package declarations"

    # Step 5: Update import statements in all Java files
    echo "   🔄 Updating import statements..."
    find src -name "*.java" -type f -exec sed -i "s/import org\.flossware\.$old_pkg/import org.flossware.$new_pkg/g" {} \;
    echo "   ✅ Updated imports"

    # Step 6: Update module-info.java if exists
    if [[ -f "src/main/java/module-info.java" ]]; then
        sed -i "s/org\.flossware\.$old_pkg/org.flossware.$new_pkg/g" src/main/java/module-info.java
        echo "   ✅ Updated module-info.java"
    fi

    # Step 7: Update POM
    echo "   🔄 Updating pom.xml..."

    # Update artifactId
    sed -i "s|<artifactId>$old_name</artifactId>|<artifactId>$new_name</artifactId>|g" pom.xml

    # Update version to 2.0
    sed -i '0,/<version>[^<]*<\/version>/s|<version>[^<]*</version>|<version>2.0</version>|' pom.xml

    # Update name
    local display_name=$(echo "$new_name" | sed 's/-java//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
    sed -i "s|<name>.*</name>|<name>FlossWare $display_name</name>|" pom.xml

    # Update SCM URLs
    sed -i "s|FlossWare/$old_name|FlossWare/$new_name|g" pom.xml

    # Update cross-project dependencies (other j* projects)
    for other_mapping in "${PROJECTS[@]}"; do
        IFS=':' read -r other_old other_new _ _ <<< "$other_mapping"
        if [[ "$other_old" != "$old_name" ]]; then
            sed -i "s|<artifactId>$other_old</artifactId>|<artifactId>$other_new</artifactId>|g" pom.xml
        fi
    done

    echo "   ✅ Updated pom.xml"

    # Step 8: Update README if exists
    if [[ -f "README.md" ]]; then
        sed -i "s/$old_name/$new_name/g" README.md
        sed -i "s/org\.flossware\.$old_pkg/org.flossware.$new_pkg/g" README.md
        echo "   ✅ Updated README.md"
    fi

    # Step 9: Commit changes
    echo "   🔄 Committing changes..."
    git add -A
    git commit -m "$(cat <<EOF
Rename project: $old_name → $new_name

Breaking Changes:
- Repository: $old_name → $new_name
- Artifact: $old_name → $new_name
- Package: org.flossware.$old_pkg → org.flossware.$new_pkg
- Version: bumped to 2.0

This is a MAJOR version bump due to breaking changes.

Migration Guide:
- Update dependency artifactId: $old_name → $new_name
- Update imports: org.flossware.$old_pkg → org.flossware.$new_pkg
- Update version to 2.0

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
    echo "   ✅ Changes committed"

    # Step 10: Push to GitHub
    echo "   🔄 Pushing to GitHub..."
    if git push; then
        echo "   ✅ Pushed to GitHub"
    else
        echo "   ⚠️  Failed to push (may need to set upstream)"
        echo "   💡 Run: git push --set-upstream origin main"
    fi

    # Step 11: Rename local directory
    echo "   🔄 Renaming local directory..."
    cd "$PARENT_DIR"
    if [[ "$old_name" != "$new_name" ]]; then
        mv "$old_name" "$new_name"
        echo "   ✅ Renamed: $old_name → $new_name"
    fi

    echo "   ✅ COMPLETE: $new_name"
    echo
}

# Process projects
if [[ "$APPLY_ALL" == true ]]; then
    echo "Renaming all projects..."
    echo

    for mapping in "${PROJECTS[@]}"; do
        rename_project "$mapping"
    done
elif [[ -n "$TARGET_PROJECT" ]]; then
    # Find matching project
    found=false
    for mapping in "${PROJECTS[@]}"; do
        IFS=':' read -r old_name _ _ _ <<< "$mapping"
        if [[ "$old_name" == "$TARGET_PROJECT" ]]; then
            rename_project "$mapping"
            found=true
            break
        fi
    done

    if [[ "$found" == false ]]; then
        echo "Error: Project not found: $TARGET_PROJECT"
        echo
        echo "Available projects:"
        for mapping in "${PROJECTS[@]}"; do
            IFS=':' read -r old_name new_name _ _ <<< "$mapping"
            echo "  $old_name → $new_name"
        done
        exit 1
    fi
else
    echo "Error: Must specify --all or --project <name>"
    echo "Usage: $0 [--all | --project <old-name>] [--dry-run]"
    exit 1
fi

echo "========================================"
echo "Summary"
echo "========================================"
if [[ "$DRY_RUN" == true ]]; then
    echo "Dry run complete. No changes made."
    echo "Run without --dry-run to execute renames."
else
    echo "Project renames complete!"
    echo
    echo "⚠️  BREAKING CHANGES - Version 2.0"
    echo
    echo "Users must update:"
    echo "  1. Maven dependencies (artifactId changed)"
    echo "  2. Import statements (package names changed)"
    echo "  3. Versions to 2.0"
    echo
    echo "📋 Next Steps:"
    echo "  1. Verify all builds work: cd {project} && mvn clean verify"
    echo "  2. Update cross-project dependencies"
    echo "  3. Create migration guide for users"
    echo "  4. Announce breaking changes"
fi
echo
