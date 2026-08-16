#!/bin/bash
#
# Apply FlossWare Gradle Build Standards to Projects
#
# Usage:
#   ./rollout-gradle-standards.sh --all                    # Apply to all Gradle projects
#   ./rollout-gradle-standards.sh --project ../some-app    # Apply to specific project
#   ./rollout-gradle-standards.sh --all --dry-run          # Preview changes only
#   ./rollout-gradle-standards.sh --all --pragmatic-coverage  # Use 100% with sensible exclusions
#   ./rollout-gradle-standards.sh --all --kotlin-dsl       # Use Kotlin DSL templates
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
DRY_RUN=false
PRAGMATIC_COVERAGE=false
KOTLIN_DSL=false
TARGET_PROJECT=""
APPLY_ALL=false

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
        --pragmatic-coverage)
            PRAGMATIC_COVERAGE=true
            shift
            ;;
        --kotlin-dsl)
            KOTLIN_DSL=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--all | --project <path>] [--dry-run] [--pragmatic-coverage] [--kotlin-dsl]"
            exit 1
            ;;
    esac
done

if [[ "$APPLY_ALL" == false && -z "$TARGET_PROJECT" ]]; then
    echo "Error: Must specify --all or --project <path>"
    echo
    echo "Usage:"
    echo "  $0 --all                          # Apply to all Gradle projects"
    echo "  $0 --project ../some-app          # Apply to specific project"
    echo "  $0 --all --dry-run                # Preview only"
    echo "  $0 --all --pragmatic-coverage     # Use 100% with sensible exclusions"
    echo "  $0 --all --kotlin-dsl             # Use Kotlin DSL templates"
    exit 1
fi

echo "========================================"
echo "FlossWare Gradle Standards Rollout"
echo "========================================"
echo "Version: 1.0"
echo "Dry Run: $DRY_RUN"
echo "Pragmatic Coverage: $PRAGMATIC_COVERAGE"
echo "Kotlin DSL: $KOTLIN_DSL"
echo
echo "Applies:"
echo "  - Checkstyle (Code Style)"
echo "  - PMD (Code Quality)"
echo "  - SpotBugs (Bug Detection)"
echo "  - JaCoCo (Code Coverage)"
echo "  - Version Format Validation (X.Y)"
echo "  - OWASP Dependency Check (opt-in)"
echo

apply_standards() {
    local project_dir="$1"
    local project_name
    project_name=$(basename "$project_dir")

    echo "Processing: $project_name"
    echo "   Path: $project_dir"

    local has_groovy=false
    local has_kotlin=false

    [[ -f "$project_dir/build.gradle" ]] && has_groovy=true
    [[ -f "$project_dir/build.gradle.kts" ]] && has_kotlin=true

    if [[ "$has_groovy" == false && "$has_kotlin" == false ]]; then
        echo "   SKIPPED - No build.gradle or build.gradle.kts found"
        echo
        return
    fi

    if grep -q "org.flossware.standards" "$project_dir/build.gradle" 2>/dev/null || \
       grep -q "org.flossware.standards" "$project_dir/build.gradle.kts" 2>/dev/null; then
        echo "   SKIPPED - Standards already applied"
        echo
        return
    fi

    if [[ "$DRY_RUN" == true ]]; then
        echo "   Would apply standards (dry run)"
        check_existing "$project_dir" "$has_groovy" "$has_kotlin"
        echo
        return
    fi

    # Copy .editorconfig
    if [[ ! -f "$project_dir/.editorconfig" ]]; then
        cp "$SCRIPT_DIR/.editorconfig" "$project_dir/.editorconfig"
        echo "   Copied .editorconfig"
    fi

    # Determine DSL type
    local dsl_type="groovy"
    if [[ "$KOTLIN_DSL" == true ]] || [[ "$has_kotlin" == true && "$has_groovy" == false ]]; then
        dsl_type="kotlin"
    fi

    local coverage_mode="strict"
    if [[ "$PRAGMATIC_COVERAGE" == true ]]; then
        coverage_mode="pragmatic"
    fi

    echo "   DSL Type: $dsl_type"
    echo "   Coverage Mode: $coverage_mode"
    echo
    echo "   Add to your settings file (settings.gradle$([ "$dsl_type" = "kotlin" ] && echo '.kts')):"
    echo

    if [[ "$dsl_type" == "kotlin" ]]; then
        echo '   pluginManagement {'
        echo '       repositories {'
        echo '           maven {'
        echo '               url = uri("https://packagecloud.io/flossware/releases/maven2/")'
        echo '           }'
        echo '           gradlePluginPortal()'
        echo '           mavenCentral()'
        echo '       }'
        echo '   }'
    else
        echo '   pluginManagement {'
        echo '       repositories {'
        echo '           maven {'
        echo "               url 'https://packagecloud.io/flossware/releases/maven2/'"
        echo '           }'
        echo '           gradlePluginPortal()'
        echo '           mavenCentral()'
        echo '       }'
        echo '   }'
    fi

    echo
    echo "   Add to your build file (build.gradle$([ "$dsl_type" = "kotlin" ] && echo '.kts')):"
    echo

    if [[ "$dsl_type" == "kotlin" ]]; then
        echo '   plugins {'
        echo '       id("org.flossware.standards") version "2.0"'
        echo '   }'
        echo
        echo '   flosswareStandards {'
        echo "       coverageMode.set(\"$coverage_mode\")"
        echo '       javaVersion.set(21)'
        echo '   }'
    else
        echo '   plugins {'
        echo "       id 'org.flossware.standards' version '2.0'"
        echo '   }'
        echo
        echo '   flosswareStandards {'
        echo "       coverageMode = '$coverage_mode'"
        echo '       javaVersion = 21'
        echo '   }'
    fi

    echo
    echo "   DONE - After applying, run: cd $project_dir && ./gradlew check"
    echo

    # Show template reference
    if [[ "$dsl_type" == "kotlin" ]]; then
        echo "   Full template: $SCRIPT_DIR/gradle/templates/consumer-kotlin/"
    else
        echo "   Full template: $SCRIPT_DIR/gradle/templates/consumer-groovy/"
    fi
    echo
}

check_existing() {
    local project_dir="$1"
    local has_groovy="$2"
    local has_kotlin="$3"

    echo "   Current Status:"

    local build_file
    if [[ "$has_kotlin" == true ]]; then
        build_file="$project_dir/build.gradle.kts"
    else
        build_file="$project_dir/build.gradle"
    fi

    local has_checkstyle
    has_checkstyle=$(grep -c "checkstyle" "$build_file" 2>/dev/null || echo "0")
    local has_pmd
    has_pmd=$(grep -c "pmd" "$build_file" 2>/dev/null || echo "0")
    local has_spotbugs
    has_spotbugs=$(grep -c "spotbugs" "$build_file" 2>/dev/null || echo "0")
    local has_jacoco
    has_jacoco=$(grep -c "jacoco" "$build_file" 2>/dev/null || echo "0")

    echo "      Checkstyle:  $([[ $has_checkstyle -gt 0 ]] && echo 'YES' || echo 'NO')"
    echo "      PMD:         $([[ $has_pmd -gt 0 ]] && echo 'YES' || echo 'NO')"
    echo "      SpotBugs:    $([[ $has_spotbugs -gt 0 ]] && echo 'YES' || echo 'NO')"
    echo "      JaCoCo:      $([[ $has_jacoco -gt 0 ]] && echo 'YES' || echo 'NO')"
    [[ -f "$project_dir/.editorconfig" ]] && echo "      .editorconfig: YES" || echo "      .editorconfig: NO"
}

if [[ "$APPLY_ALL" == true ]]; then
    echo "Searching for Gradle projects in: $PARENT_DIR"
    echo

    find "$PARENT_DIR" -maxdepth 2 \( -name "build.gradle" -o -name "build.gradle.kts" \) -type f | while read -r build_file; do
        project_dir="$(dirname "$build_file")"

        # Skip build-tools itself and the gradle plugin subproject
        if [[ "$project_dir" == "$SCRIPT_DIR" ]] || [[ "$project_dir" == "$SCRIPT_DIR/gradle" ]]; then
            continue
        fi

        # Skip subdirectories of projects (only process root build files)
        local relative="${project_dir#$PARENT_DIR/}"
        if [[ "$relative" == *"/"*"/"* ]]; then
            continue
        fi

        apply_standards "$project_dir"
    done
else
    if [[ ! -d "$TARGET_PROJECT" ]]; then
        echo "Error: Directory not found: $TARGET_PROJECT"
        exit 1
    fi

    apply_standards "$TARGET_PROJECT"
fi

echo "========================================"
echo "Summary"
echo "========================================"
if [[ "$DRY_RUN" == true ]]; then
    echo "Dry run complete. No changes made."
    echo "Run without --dry-run to apply changes."
else
    echo "Rollout complete!"
    echo
    echo "Next steps for each project:"
    echo "  1. Add pluginManagement block to settings.gradle(.kts)"
    echo "  2. Add plugin and flosswareStandards block to build.gradle(.kts)"
    echo "  3. Run: ./gradlew check"
    echo "  4. Fix any violations"
    echo "  5. Commit: git commit -am 'Apply FlossWare Gradle standards'"
    echo
    echo "Templates:"
    echo "  Groovy DSL: $SCRIPT_DIR/gradle/templates/consumer-groovy/"
    echo "  Kotlin DSL: $SCRIPT_DIR/gradle/templates/consumer-kotlin/"
fi
