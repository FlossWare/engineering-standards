#!/bin/bash
#
# Fix Documentation References
#
# Updates README.md and site files to use new artifact names
#

PARENT_DIR="/home/sfloess/Development/github/FlossWare"

# Mapping of old to new names
declare -A MAPPING=(
    ["jcommons"]="commons-java"
    ["jcollections"]="collections-java"
    ["jcurses"]="curses-java"
    ["jclassloader"]="classloader-java"
    ["jcloudstorage"]="cloudstorage-java"
    ["jcontainer"]="container-java"
    ["jdiskwipe"]="diskwipe-java"
    ["jencrypt"]="encrypt-java"
    ["jeventbus"]="eventbus-java"
    ["jfiletransfer"]="filetransfer-java"
    ["jfs-watcher"]="fs-watcher-java"
    ["jmessaging"]="messaging-java"
    ["jnexus"]="nexus-java"
    ["jplatform"]="platform-java"
    ["jremote"]="remote-java"
    ["jresource-monitor"]="resource-monitor-java"
    ["jresource"]="resourcemonitor"
    ["jthreadpool"]="threadpool-java"
    ["jvcs"]="vcs-java"
)

echo "========================================"
echo "Fix Documentation References"
echo "========================================"
echo

for project in "$PARENT_DIR"/*-java; do
    project_name=$(basename "$project")
    echo "📦 $project_name"

    changed=false

    # Fix README.md
    if [[ -f "$project/README.md" ]]; then
        for old in "${!MAPPING[@]}"; do
            new="${MAPPING[$old]}"

            # Fix artifact IDs
            if grep -q "<artifactId>$old</artifactId>" "$project/README.md"; then
                sed -i "s|<artifactId>$old</artifactId>|<artifactId>$new</artifactId>|g" "$project/README.md"
                changed=true
            fi

            # Fix GitHub URLs
            if grep -q "github.com/FlossWare/$old" "$project/README.md"; then
                sed -i "s|github.com/FlossWare/$old|github.com/FlossWare/$new|g" "$project/README.md"
                changed=true
            fi

            # Fix package names (org.flossware.j*)
            if grep -q "org\\.flossware\\.$old" "$project/README.md"; then
                # Get the package part without 'j' prefix
                pkg_new=$(echo "$old" | sed 's/^j//')
                sed -i "s|org\\.flossware\\.$old|org.flossware.$pkg_new|g" "$project/README.md"
                changed=true
            fi
        done
    fi

    # Fix src/site/site.xml
    if [[ -f "$project/src/site/site.xml" ]]; then
        for old in "${!MAPPING[@]}"; do
            new="${MAPPING[$old]}"

            if grep -q "FlossWare/$old" "$project/src/site/site.xml"; then
                sed -i "s|FlossWare/$old|FlossWare/$new|g" "$project/src/site/site.xml"
                changed=true
            fi
        done
    fi

    # Fix src/site/markdown/index.md
    if [[ -f "$project/src/site/markdown/index.md" ]]; then
        for old in "${!MAPPING[@]}"; do
            new="${MAPPING[$old]}"

            if grep -q "<artifactId>$old</artifactId>" "$project/src/site/markdown/index.md"; then
                sed -i "s|<artifactId>$old</artifactId>|<artifactId>$new</artifactId>|g" "$project/src/site/markdown/index.md"
                changed=true
            fi
        done
    fi

    if [[ "$changed" == true ]]; then
        cd "$project"
        git add README.md src/site/ 2>/dev/null
        if git commit -m "Fix documentation references to use new artifact names

Updated:
- README.md: j* → *-java artifact names and URLs
- src/site/site.xml: GitHub URLs
- src/site/markdown/index.md: artifact names

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"; then
            echo "   ✅ Committed"

            if git push; then
                echo "   ✅ Pushed"
            else
                echo "   ⚠️  Push failed"
            fi
        else
            echo "   ⚠️  Nothing to commit (no changes)"
        fi
    else
        echo "   ℹ️  No changes needed"
    fi

    echo
done

echo "========================================"
echo "Complete"
echo "========================================"
