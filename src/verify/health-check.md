# Health Check

Verify the project was set up correctly after all modules have executed.

## Input

- `project-context.json`: all fields (to know which checks apply)
- `{project_path}/.claude/launchpad/blueprint.md`: which modules were included/skipped

## Flow

### Step 1: Load context

1. Read `{project_path}/project-context.json`
2. Read `{project_path}/.claude/launchpad/blueprint.md` to determine which modules ran
3. Build a checklist of applicable checks based on what was included

### Step 2: Run checks

Execute each check and record PASS or FAIL with details.

#### Core checks (always run)

| # | Check | Command | Pass condition |
|---|-------|---------|----------------|
| 1 | Git initialized | `test -d {project_path}/.git` | .git/ directory exists |
| 2 | .gitignore exists | `test -f {project_path}/.gitignore` | File exists and is non-empty |
| 3 | CLAUDE.md exists | `test -f {project_path}/CLAUDE.md` | File exists and is non-empty |
| 4 | Claude settings | `cat {project_path}/.claude/settings.json \| python3 -m json.tool` | File exists and is valid JSON |

#### Conditional checks (run if module was included)

| # | Check | Condition | Command | Pass condition |
|---|-------|-----------|---------|----------------|
| 5 | AGENTS.md exists | agents-generator included | `test -f {project_path}/AGENTS.md` | File exists |
| 6 | Skills installed | skills-installer included | `ls {project_path}/.claude/skills/*/SKILL.md` | At least one SKILL.md found |
| 7 | Agent configs created | agents-generator included | `ls {project_path}/.claude/agents/*.md` | At least one agent .md found |
| 8 | MCP servers connected | memory-setup included | `claude mcp list 2>/dev/null \| grep -i mempalace` | mempalace appears in MCP list |
| 9 | Hooks configured | claude-settings included | Read settings.json, check `hooks` key has entries | At least one hook defined |
| 10 | Code standards files | code-standards included | `ls {project_path}/docs/*standards*` | At least one standards file found |
| 11 | .editorconfig exists | code-standards included | `test -f {project_path}/.editorconfig` | File exists |
| 12 | PM directories | pm-setup included | `test -d {project_path}/plans/reports` | plans/reports/ exists |
| 13 | PM system installed | pm-setup included | `test -d ~/.ccpm` | CCPM directory exists |
| 14 | tmux config | workspace-setup included | `test -f {project_path}/.claude/launchpad/start.sh` | Start script exists and is executable |
| 15 | Blueprint saved | always | `test -f {project_path}/.claude/launchpad/blueprint.md` | Blueprint file exists |

### Step 3: Display results

Present results as a table:

```
Health Check Results for {project_name}
========================================

| #  | Check                  | Status | Details              |
|----|------------------------|--------|----------------------|
| 1  | Git initialized        | PASS   |                      |
| 2  | .gitignore exists      | PASS   |                      |
| 3  | CLAUDE.md exists       | PASS   |                      |
| 4  | Claude settings        | PASS   | Valid JSON           |
| 5  | AGENTS.md exists       | PASS   |                      |
| 6  | Skills installed       | PASS   | 2 skills found       |
| 7  | Agent configs          | PASS   | 3 agents found       |
| 8  | MCP servers            | FAIL   | mempalace not found  |
| 9  | Hooks configured       | PASS   | 2 hooks defined      |
| 10 | Code standards         | PASS   | 2 files found        |
| 11 | .editorconfig          | PASS   |                      |
| 12 | PM directories         | PASS   |                      |
| 13 | PM system installed    | PASS   |                      |
| 14 | tmux config            | SKIP   | Module was skipped   |
| 15 | Blueprint saved        | PASS   |                      |

Score: 13/14 passed (1 failed, 1 skipped)
```

Status values:
- **PASS** - check succeeded
- **FAIL** - check failed, needs attention
- **SKIP** - module was not included in blueprint, check not applicable

### Step 4: Fix suggestions

For each FAIL, provide a specific fix suggestion:

| Check | Fix suggestion |
|-------|----------------|
| Git initialized | Run `git init` in the project directory |
| .gitignore exists | Run `curl -sL "https://www.toptal.com/developers/gitignore/api/{template}" > .gitignore` |
| CLAUDE.md exists | Run the rules-generator module manually |
| Claude settings invalid | Check JSON syntax in .claude/settings.json |
| AGENTS.md missing | Run the agents-generator module manually |
| Skills not found | Check registry/skills-sources.json and retry skills-installer |
| Agent configs missing | Run agents-generator module manually |
| MCP not connected | Run `claude mcp add mempalace node ~/.mempalace/mcp-server/index.js` |
| Hooks not configured | Add hooks manually to .claude/settings.json |
| Code standards missing | Copy from ~/.launchpad/presets/{type}/standards/ |
| .editorconfig missing | Run code-standards module manually |
| PM directories missing | Run `mkdir -p plans/reports docs` |
| PM system not installed | Run `git clone https://github.com/pchaganti/gx-ccpm.git ~/.ccpm && cd ~/.ccpm && ./install.sh` |
| tmux config missing | Run workspace-setup module manually |
| Blueprint missing | Non-critical, setup still functional |

### Step 5: Final summary

Display one of these conclusions:

**All passed:**
```
All checks passed! Your project is ready.
Next steps:
- cd {project_path}
- Run `claude` to start Claude Code
- Or run `.claude/launchpad/start.sh` for the full tmux workspace
```

**Some failed:**
```
{n} checks failed. See fix suggestions above.
You can re-run individual modules or apply fixes manually.
The project is partially set up and usable for the items that passed.
```

**Critical failures (Git or CLAUDE.md missing):**
```
Critical checks failed. The project setup is incomplete.
Please fix the critical items before using the project with Claude Code.
```

## Rules

- Never auto-fix failures. Only suggest fixes and let the user decide
- Skipped checks do not count as failures
- Translate all output to the user's detected language
- Health check is read-only. It must not modify any files
