# AI Assistant Permissions Configuration

Configuration guide for AI coding assistant auto-accept settings.

## Overview

This document explains the permission system used by AI coding assistants in this project. The configuration allows automated operations while maintaining safety boundaries.

## Configuration File

**Location:** `.claude/settings.json` (or equivalent for your AI assistant)

The configuration file defines which operations the AI assistant can perform automatically without requiring user confirmation.

## Permission Categories

### 1. Read Operations

**Status:** Auto-accepted

Read operations are safe and non-destructive:
- Reading files
- Listing directories
- Viewing file contents
- Inspecting repository state

### 2. Write Operations

**Status:** Auto-accepted (with patterns)

File creation and modification operations:
- Creating new files
- Writing content to files
- All file patterns: `*`

**Safety:** Changes are version-controlled via Git

### 3. Edit Operations

**Status:** Auto-accepted (with patterns)

In-place file modifications:
- Editing existing files
- String replacements
- All file patterns: `*`

**Safety:** Changes are version-controlled via Git

### 4. Bash Commands

**Status:** Auto-accepted (specific patterns)

Shell command execution for common operations:

**Always Allowed:**
- All commands: `*` (basic pattern)
- Python execution: `python *`, `python3 *`
- Script execution: `./scripts/*.py`, `./*.py`
- Find with exec: `find * -exec *`

**Commonly Allowed (see project config):**
- Git operations: `git status`, `git log`, `git diff`, `git add`, `git commit`, `git push`
- Build tools: `mvn *`, `./mvnw *`, `gradle *`
- File operations: `ls`, `find`, `grep`, `cat`, `head`, `tail`, `tree`
- System info: `pwd`, `whoami`, `hostname`, `uname`

### 5. Task Management

**Status:** Auto-accepted

Project task tracking:
- TaskCreate
- TaskUpdate
- TaskList
- TaskGet

### 6. Workflow & Agent Tools

**Status:** Auto-accepted

Advanced AI capabilities:
- Workflow orchestration
- Sub-agent spawning

## Safety Boundaries

### Explicitly Denied Operations

Some operations are explicitly blocked for safety:

**File System:**
- `rm -rf /` - System-wide deletion
- `mkfs *` - Filesystem formatting
- `dd if=* of=/dev/*` - Direct device writes
- `chmod -R 777 /` - Unsafe permission changes
- Editing system files: `/etc/*`
- Editing home config: `/home/user/.*`

**Git Operations:**
- `git push * --force` - Force pushes
- `git reset --hard HEAD~*` - Hard resets

## Configuration Example

```json
{
  "permissions": {
    "allow": [
      "Bash",
      "Write",
      "Edit",
      "Read",
      "TaskCreate",
      "TaskUpdate",
      "TaskList",
      "TaskGet",
      "Workflow",
      "Agent"
    ],
    "alwaysAllow": {
      "tools": [
        {
          "name": "Bash",
          "patterns": ["*"]
        },
        {
          "name": "Bash",
          "patterns": [
            "python *",
            "python3 *",
            "./scripts/*.py",
            "./*.py",
            "find * -exec *"
          ]
        },
        {
          "name": "Write",
          "patterns": ["*"]
        },
        {
          "name": "Edit",
          "patterns": ["*"]
        }
      ]
    }
  }
}
```

## Benefits

### Productivity

- **No interruption:** Automated operations proceed without permission prompts
- **Faster iteration:** AI can execute multi-step tasks without breaks
- **Continuous workflows:** Long-running tasks complete unattended

### Safety

- **Git safety net:** All file changes are version-controlled
- **Explicit denials:** Dangerous operations are blocked
- **Reversible changes:** Git allows rollback of any changes

### Consistency

- **Reproducible:** Same operations work across team members
- **Documented:** Clear record of allowed operations
- **Auditable:** Git history tracks all AI-made changes

## Usage Patterns

### Development Workflow

1. AI makes code changes (auto-accepted edits)
2. AI runs tests (auto-accepted bash commands)
3. AI commits changes (auto-accepted git operations)
4. Human reviews the commit before push

### Code Review Automation

1. AI scans codebase (auto-accepted read operations)
2. AI runs quality checks (auto-accepted bash commands)
3. AI creates issues (auto-accepted write operations)
4. AI suggests fixes (auto-accepted edit operations)

### Build Automation

1. AI reads build configuration (auto-accepted)
2. AI runs build commands (auto-accepted mvn/gradle)
3. AI analyzes build output (auto-accepted read)
4. AI updates documentation (auto-accepted write/edit)

## Best Practices

### For Users

1. **Review git changes:** Always review commits before pushing
2. **Understand permissions:** Know what operations are auto-accepted
3. **Use version control:** Ensure all work is in a git repository
4. **Monitor output:** Watch for unexpected operations

### For AI Assistants

1. **Explain actions:** Describe what you're doing before execution
2. **Group operations:** Batch related operations efficiently
3. **Provide context:** Help users understand the changes
4. **Flag risks:** Warn users about potentially destructive operations

## Customization

### Adding Permissions

To allow additional operations, add patterns to `.claude/settings.json`:

```json
{
  "name": "Bash",
  "patterns": [
    "your-custom-command *"
  ]
}
```

### Removing Permissions

To restrict operations, remove patterns or add to deny list:

```json
"deny": [
  "Bash(your-restricted-command *)"
]
```

### Project-Specific Config

Each project can have its own `.claude/settings.json` that overrides parent configurations.

## Troubleshooting

### Permission Denied

If an operation is blocked:
1. Check `.claude/settings.json` for allowed patterns
2. Add the pattern if it's safe
3. Run the operation manually if uncertain

### Unexpected Auto-Approval

If unwanted operations are auto-accepted:
1. Review the `alwaysAllow` patterns
2. Remove overly broad patterns (like `*`)
3. Add specific deny rules

## AI Assistant Compatibility

This configuration format is designed for:
- Claude Code (primary)
- Other AI coding assistants (adapt as needed)

**Format variations:**
- Different tools may use different config file names
- JSON structure may vary between implementations
- Consult your AI assistant's documentation

## Version Control

**Recommended:** Commit `.claude/settings.json` to version control

**Benefits:**
- Team consistency
- Configuration history
- Easy rollback
- Documented permissions

**Add to `.gitignore` if:**
- Permissions contain sensitive patterns
- Team members need different configs

## Security Notes

1. **Trust boundary:** Auto-accept assumes you trust the AI assistant
2. **Review commits:** Human review is the final safety check
3. **Sensitive operations:** Keep destructive operations in deny list
4. **Environment-specific:** Separate configs for dev/prod environments

## Further Reading

- Project-specific: `.claude/START_HERE.md`
- AI Assistant docs: Check your assistant's documentation
- Git best practices: Standard git workflow guides

---

**Last Updated:** 2026-05-31  
**Applies To:** FlossWare build-tools and related projects  
**Maintainer:** Project team
