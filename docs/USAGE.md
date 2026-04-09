# Usage Guide

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/xgirl2510-ops/launchpad/main/install.sh | bash
```

Or clone manually:

```bash
git clone https://github.com/xgirl2510-ops/launchpad.git ~/.launchpad
cd ~/.launchpad && bash install.sh
```

The installer clones to `~/.launchpad/`, symlinks the skill, and verifies prerequisites (git, gh, node).

## Running Launchpad

Open Claude Code in any directory and run:

```
/launch
```

Or say: "bootstrap project", "setup project", "new project"

Launchpad detects your language and conducts the entire flow in it.

## Step-by-step walkthrough

### Phase 1: Interview

Launchpad asks questions in 3 groups:

**Basics** - project name, type, description, repo status, visibility

**Team** - solo or agent-teams, project management (CCPM), memory (MemPalace)

**Stack** - tech stack, additional skills

Optional questions can be skipped by typing "skip". After all questions, you see a summary table and can edit any answer before proceeding.

### Phase 2: Blueprint

Launchpad loads the matching preset, merges your answers, and generates a blueprint showing:

- Project overview table
- Module list with include/skip status
- Details for each module (what it creates, from where)

The blueprint is saved to `{project}/.claude/launchpad/blueprint.md`.

### Phase 3: Review

You review the blueprint and choose:

- **yes** - proceed to execution
- **edit** - toggle modules, add/remove skills, change values
- **cancel** - abort

### Phase 4: Execute

Each module runs in order. Before each one, you see what it will do and confirm:

- **yes** - run the module
- **skip** - skip it
- **cancel** - stop (completed modules remain)

### Phase 5: Health check

Launchpad verifies the setup with 15 checks (git, CLAUDE.md, settings, skills, agents, MCP, hooks, standards, PM, workspace). Failed checks include specific fix commands.

---

## Example: Unity game project

```
> /launch

Launchpad - AI-first project bootstrapper.
Let's set up your project.

? Project name?
> my-unity-rpg

? Project type?
> unity-game

? Brief project description?
> A 2D RPG with turn-based combat

? Create new repo or use existing?
> new

? Repo visibility?
> private

? Solo or Agent Teams?
> agent-teams

? Need project management (CCPM)?
> yes

? Need persistent memory (MemPalace)?
> yes

? Primary tech stack?
> Unity 2022 LTS + C#

? Any additional skills needed?
> skip

Summary:
| Field             | Value                         |
|-------------------|-------------------------------|
| project_name      | my-unity-rpg                  |
| project_type      | unity-game                    |
| description       | A 2D RPG with turn-based combat |
| repo_status       | new                           |
| repo_visibility   | private                       |
| team_mode         | agent-teams                   |
| need_pm           | true                          |
| need_memory       | true                          |
| tech_stack        | Unity 2022 LTS + C#           |

? Everything correct? (yes / edit)
> yes

Blueprint generated. Modules: 10/10 included.
? Approve this blueprint? (yes / edit / cancel)
> yes

Module 1/10: repo-setup
  Action: git init, .gitignore (Unity), gh repo create --private
  ? Run this module? (yes / skip / cancel)
  > yes
  Done. Created .git/, .gitignore, GitHub remote.

Module 2/10: claude-settings
  ...

(continues for all 10 modules)

Health check: 15/15 passed.
Your project is ready! cd my-unity-rpg && claude
```

## Example: SaaS web project

```
> /launch

? Project name?
> my-saas-app

? Project type?
> saas-web

? Brief project description?
> SaaS platform for team task management

? Create new repo or use existing?
> existing

? Repo URL (if existing)?
> https://github.com/myorg/my-saas-app

? Repo visibility?
> private

? Solo or Agent Teams?
> solo

? Need project management (CCPM)?
> yes

? Need persistent memory (MemPalace)?
> no

? Primary tech stack?
> Next.js 15 + TypeScript + Supabase

? Any additional skills needed?
> playwright-testing

Blueprint generated. Modules: 9/10 included (repo-setup skipped - existing repo).
```

Key differences from Unity example:
- `repo-setup` auto-skipped (existing repo)
- `memory-setup` skipped (user opted out)
- SaaS preset adds: src/app/, src/components/, prisma/ directories
- Additional skill `playwright-testing` appended to preset skills

---

## Creating a custom preset

Create a new directory under `~/.launchpad/presets/`:

```
presets/my-preset/
├── preset.json       # Required: module config and defaults
├── skills.json       # Required: skills to install
├── agents.json       # Required: agents to generate
├── standards/        # Optional: code standard .md files
└── rules/            # Optional: CLAUDE.md rule templates
```

### preset.json structure

```json
{
  "type": "my-preset",
  "name": "My Custom Preset",
  "description": "Description of this preset",
  "default_tech_stack": "Your default stack",
  "directories": ["src", "docs", "plans", "plans/reports"],
  "gitignore_template": "Node",
  "modules": {
    "repo-setup": { "enabled": true },
    "claude-settings": {
      "enabled": true,
      "config": {
        "agent_teams": false,
        "hooks": ["Stop"]
      }
    },
    "skills-installer": {
      "enabled": true,
      "skills": [
        { "name": "code-reviewer", "source": "alirezarezvani/claude-skills" }
      ]
    },
    "agents-generator": {
      "enabled": true,
      "agents": [
        { "name": "reviewer", "description": "Code review agent" }
      ]
    },
    "memory-setup": { "enabled": true, "system": "mempalace", "wings": [] },
    "pm-setup": { "enabled": true, "system": "ccpm" },
    "code-standards": { "enabled": true, "files": [] },
    "rules-generator": { "enabled": true, "template": "rules/my-rules.md" },
    "templates-scaffold": { "enabled": true, "structure": "custom" },
    "workspace-setup": { "enabled": true, "tmux": true }
  }
}
```

Then users can select `my-preset` as their project type during the interview.

## Adding skills to the registry

Edit `~/.launchpad/registry/skills-sources.json`:

```json
{
  "sources": {
    "your-org/your-repo": {
      "type": "github-plugin",
      "install": "/plugin marketplace add your-org/your-repo"
    }
  },
  "skills": {
    "your-skill": {
      "source": "your-org/your-repo",
      "package": "skill-package-name"
    }
  }
}
```

Source types:
- `github-plugin` - installed via `/plugin marketplace add`
- `github-clone` - cloned and copied manually

## Overriding module behavior

### Skip a module

During blueprint review, edit the blueprint to set a module's status to "skip". Or during execution, choose "skip" when prompted.

### Modify a module's config

Edit the preset's `preset.json` before running `/launch`. Module configs in `preset.json` are the source of truth.

For one-time overrides, edit the blueprint after generation (Phase 3) before approving.

### Replace a module entirely

Create a custom module file at `~/.launchpad/src/modules/my-module.md` following the same structure (Purpose, Input, Confirmation, Steps, Output, Rollback). Reference it from your preset.

---

## Troubleshooting

### `/launch` not recognized

Launchpad skill not symlinked. Re-run the installer:
```bash
cd ~/.launchpad && bash install.sh
```

### `gh repo create` fails

GitHub CLI not authenticated. Run:
```bash
gh auth login
```

### Skills fail to install

Check network connectivity and verify the source exists in `registry/skills-sources.json`. Try installing manually:
```bash
git clone --depth 1 https://github.com/{source-org}/{source-repo} /tmp/skill-check
ls /tmp/skill-check/skills/
```

### MemPalace MCP not connecting

Verify installation:
```bash
test -d ~/.mempalace && echo "installed" || echo "not installed"
```

Re-register MCP server:
```bash
claude mcp add mempalace node ~/.mempalace/mcp-server/index.js
```

### CCPM not found

Verify installation:
```bash
test -d ~/.ccpm && echo "installed" || echo "not installed"
```

Re-install:
```bash
git clone https://github.com/pchaganti/gx-ccpm.git ~/.ccpm
cd ~/.ccpm && chmod +x install.sh && ./install.sh
```

### Health check shows failures

Run the suggested fix commands from the health check output. Each failure includes a specific command to resolve it.

### Existing project has .claude/ or CLAUDE.md

Launchpad warns before overwriting. Choose to:
- Back up existing files and proceed
- Cancel and merge manually
- Skip the conflicting modules
