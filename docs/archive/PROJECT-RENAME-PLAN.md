# Project Rename Plan: j* → *-java

## Overview

Rename all FlossWare Java projects from `j{name}` to `{name}-java` and update package names accordingly.

---

## Proposed Renames

| Current | New | Package Current | Package New |
|---------|-----|----------------|-------------|
| jcommons | commons-java | org.flossware.jcommons | org.flossware.commons |
| jcollections | collections-java | org.flossware.jcollections | org.flossware.collections |
| jcurses | curses-java | org.flossware.jcurses | org.flossware.curses |
| jclassloader | classloader-java | org.flossware.jclassloader | org.flossware.classloader |
| jcloudstorage | cloudstorage-java | org.flossware.jcloudstorage | org.flossware.cloudstorage |
| jcontainer | container-java | org.flossware.jcontainer | org.flossware.container |
| jdiskwipe | diskwipe-java | org.flossware.jdiskwipe | org.flossware.diskwipe |
| jencrypt | encrypt-java | org.flossware.jencrypt | org.flossware.encrypt |
| jeventbus | eventbus-java | org.flossware.jeventbus | org.flossware.eventbus |
| jfiletransfer | filetransfer-java | org.flossware.jfiletransfer | org.flossware.filetransfer |
| jfs-watcher | fs-watcher-java | org.flossware.jfswatcher | org.flossware.fswatcher |
| jmessaging | messaging-java | org.flossware.jmessaging | org.flossware.messaging |
| jnexus | nexus-java | org.flossware.jnexus | org.flossware.nexus |
| jplatform | platform-java | org.flossware.jplatform | org.flossware.platform |
| jremote | remote-java | org.flossware.jremote | org.flossware.remote |
| jresource-monitor | resource-monitor-java | org.flossware.jresourcemonitor | org.flossware.resourcemonitor |
| jthreadpool | threadpool-java | org.flossware.jthreadpool | org.flossware.threadpool |
| jvcs | vcs-java | org.flossware.jvcs | org.flossware.vcs |

**Note**: gofl, netbeans-plugins don't follow j* pattern - skip or rename?

---

## What Needs to Change

### 1. GitHub Repository Names
- Rename via GitHub API

### 2. Local Directory Names
- Move local directories

### 3. Maven POM Files
- `<artifactId>` 
- `<name>`
- `<description>`
- `<scm>` URLs
- Cross-project `<dependency>` references

### 4. Java Package Names
- Rename all packages: `org.flossware.j{name}` → `org.flossware.{name}`
- Update all `package` declarations
- Update all `import` statements

### 5. Directory Structure
- Move `src/main/java/org/flossware/j{name}/` → `src/main/java/org/flossware/{name}/`
- Move `src/test/java/org/flossware/j{name}/` → `src/test/java/org/flossware/{name}/`

### 6. Documentation
- Update README files
- Update GitHub URLs
- Update package references

### 7. Configuration Files
- Update `module-info.java` (if exists)
- Update any hardcoded package references

---

## Breaking Changes

**WARNING**: This is a breaking change!

### For Existing Users
- Maven dependency coordinates change
- Package imports change
- GitHub URLs change

### Migration Required
Old:
```xml
<dependency>
    <groupId>org.flossware</groupId>
    <artifactId>jcommons</artifactId>
    <version>1.0</version>
</dependency>
```

New:
```xml
<dependency>
    <groupId>org.flossware</groupId>
    <artifactId>commons-java</artifactId>
    <version>2.0</version>  <!-- Major version bump -->
</dependency>
```

Old:
```java
import org.flossware.jcommons.Utils;
```

New:
```java
import org.flossware.commons.Utils;
```

---

## Automation Strategy

### Script: `rename-all-projects.sh`

**Tasks:**
1. For each project:
   - Rename GitHub repository
   - Rename local directory
   - Update POM (artifactId, name, scm URLs)
   - Refactor Java packages
   - Update imports across all files
   - Update cross-project dependencies
   - Commit changes
   - Push to GitHub

**Tools:**
- `gh api` - GitHub repository rename
- `mvn versions:set` - Update POM versions
- `find` + `sed` - Package/import refactoring
- Git rename detection

---

## Questions to Confirm

1. **Package naming**: 
   - Remove "j" prefix? `org.flossware.jcommons` → `org.flossware.commons`
   - Or keep? `org.flossware.jcommons` → `org.flossware.jcommons`

2. **Hyphenated names**:
   - `jfs-watcher` → `fs-watcher-java`
   - Package: `org.flossware.fswatcher` or `org.flossware.fs.watcher`?

3. **Version bump**:
   - Major version bump (1.x → 2.0) to signal breaking change?

4. **Non-j projects**:
   - `gofl` → `gofl` (keep as-is, it's Go + FlossWare)
   - `netbeans-plugins` → keep as-is?

5. **Build tools**:
   - `build-tools` → keep as-is (already renamed)
   - `jbuild-tools` artifact → rename to `build-tools-java`?

6. **Timing**:
   - All at once? Or one-by-one for testing?

---

## Recommended Approach

### Phase 1: Single Project Test
1. Pick one small project (e.g., `jencrypt`)
2. Rename completely
3. Verify builds work
4. Test cross-project dependencies
5. Document any issues

### Phase 2: Core Libraries
1. Rename foundation libraries first
2. Update dependent projects
3. Test integration

### Phase 3: All Projects
1. Batch rename remaining projects
2. Update all cross-dependencies
3. Version bump to 2.0

---

## Risk Mitigation

1. **Backups**: All projects already in Git
2. **Staged rollout**: Test on one project first
3. **Version bump**: Major version signals breaking change
4. **Documentation**: Create migration guide
5. **Reversibility**: Can rollback via Git

---

## Estimated Impact

- **20 GitHub repositories** renamed
- **~100+ Java files** per project (package declarations)
- **~500+ Java files** total (import statements)
- **20 POM files** updated
- **Cross-project dependencies** updated
- **Documentation** updated across all projects

---

## Next Steps

1. **Confirm naming strategy** (questions above)
2. **Create automation script**
3. **Test on single project**
4. **Roll out to all projects**
5. **Create migration guide for users**
