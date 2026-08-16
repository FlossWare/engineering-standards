#!/bin/bash
#
# Verify All Documentation is Updated
#

PARENT_DIR="/home/sfloess/Development/github/FlossWare"

echo "========================================"
echo "Documentation Verification"
echo "========================================"
echo

# Check for old j* references in README files
echo "🔍 Checking README.md files for old references..."
echo
for project in "$PARENT_DIR"/*-java; do
    if [[ -f "$project/README.md" ]]; then
        project_name=$(basename "$project")

        # Check for old j* artifact names
        old_artifacts=$(grep -E '<artifactId>j(commons|collections|curses|classloader|cloudstorage|container|diskwipe|encrypt|eventbus|filetransfer|messaging|nexus|platform|remote|threadpool|vcs)</artifactId>' "$project/README.md" 2>/dev/null || true)

        # Check for old package names
        old_packages=$(grep -E 'org\.flossware\.j[a-z]' "$project/README.md" 2>/dev/null || true)

        # Check for old GitHub URLs
        old_urls=$(grep -E 'github\.com/FlossWare/j[a-z]' "$project/README.md" 2>/dev/null || true)

        if [[ -n "$old_artifacts" ]] || [[ -n "$old_packages" ]] || [[ -n "$old_urls" ]]; then
            echo "❌ $project_name README.md has old references:"
            [[ -n "$old_artifacts" ]] && echo "   - Old artifact: $old_artifacts"
            [[ -n "$old_packages" ]] && echo "   - Old package: $old_packages"
            [[ -n "$old_urls" ]] && echo "   - Old URL: $old_urls"
            echo
        fi
    else
        project_name=$(basename "$project")
        echo "⚠️  $project_name - No README.md found"
        echo
    fi
done

# Check site.xml files
echo "🔍 Checking src/site/site.xml files..."
echo
for project in "$PARENT_DIR"/*-java; do
    if [[ -f "$project/src/site/site.xml" ]]; then
        project_name=$(basename "$project")

        # Check for old j* references
        old_refs=$(grep -E 'FlossWare/j[a-z]' "$project/src/site/site.xml" 2>/dev/null || true)

        if [[ -n "$old_refs" ]]; then
            echo "❌ $project_name src/site/site.xml has old references:"
            echo "$old_refs"
            echo
        fi
    fi
done

# Check site index.md files
echo "🔍 Checking src/site/markdown/index.md files..."
echo
for project in "$PARENT_DIR"/*-java; do
    if [[ -f "$project/src/site/markdown/index.md" ]]; then
        project_name=$(basename "$project")

        # Check for old j* artifact names
        old_refs=$(grep -E '<artifactId>j[a-z]|org\.flossware\.j[a-z]' "$project/src/site/markdown/index.md" 2>/dev/null || true)

        if [[ -n "$old_refs" ]]; then
            echo "❌ $project_name src/site/markdown/index.md has old references:"
            echo "$old_refs"
            echo
        fi
    fi
done

# List projects missing README.md
echo "🔍 Projects missing README.md..."
echo
for project in "$PARENT_DIR"/*-java; do
    if [[ ! -f "$project/README.md" ]]; then
        project_name=$(basename "$project")
        echo "⚠️  $project_name"
    fi
done

echo
echo "========================================"
echo "Summary"
echo "========================================"
echo "Check complete. Review output above for any issues."
echo
