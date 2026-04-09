<!-- TODO: Add logo/banner image -->
<!-- ![Launchpad Banner](docs/assets/banner.png) -->

# Launchpad

> Set up an AI-first development environment for any project in one command.

Launchpad is an open-source bootstrapper for [Claude Code](https://claude.ai/code). It interviews you about your project, generates a setup blueprint, and executes it - configuring repo, skills, agents, memory, project management, code standards, and workspace automatically.

<!-- TODO: Add demo GIF -->
<!-- ![Demo](docs/assets/demo.gif) -->

## Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/xgirl2510-ops/launchpad/main/install.sh | bash
```

Then open Claude Code in any directory and run:

```
/launch
```

Or clone manually:

```bash
git clone https://github.com/xgirl2510-ops/launchpad.git ~/.launchpad
cd ~/.launchpad && bash install.sh
```

## Features

- **One-command setup** - from zero to a fully configured AI dev environment
- **Smart interview** - asks only relevant questions, detects your language
- **Blueprint review** - see exactly what will be created before anything runs
- **Module-by-module execution** - confirm or skip each step
- **Preset system** - opinionated defaults for common project types
- **Skills installation** - auto-install Claude Code skills from the registry
- **Agent generation** - create project-specific agent definitions
- **Memory system** - persistent knowledge graph via MemPalace
- **Project management** - sprint planning and task tracking via CCPM
- **Health check** - verify everything was set up correctly

## Supported project types

| Type | Stack | Includes |
|------|-------|----------|
| `unity-game` | Unity + C# | Game-specific agents, art review, MemPalace wings for design/art/levels |
| `threejs-game` | Three.js + TypeScript | 3D web game structure, shader skills |
| `saas-web` | Next.js + TypeScript + PostgreSQL | Full-stack SaaS scaffold, API routes, Prisma |
| `api-service` | Node.js / Python | API scaffold, OpenAPI, testing setup |
| `custom` | Any | Minimal setup, you choose everything |

## How it works

Launchpad runs in 5 phases:

```
Phase 1: Interview      - Collect project info via guided questions
Phase 2: Blueprint       - Generate setup plan from answers + preset
Phase 3: Review          - User approves/edits the blueprint
Phase 4: Execute         - Run modules one by one (with confirmation)
Phase 5: Health check    - Verify everything is set up correctly
```

**Modules executed in Phase 4:**

| # | Module | What it does |
|---|--------|-------------|
| 1 | repo-setup | git init, .gitignore, GitHub remote |
| 2 | claude-settings | .claude/settings.json with hooks |
| 3 | rules-generator | CLAUDE.md with project rules |
| 4 | code-standards | Code standards + .editorconfig |
| 5 | skills-installer | Install skills from registry |
| 6 | agents-generator | AGENTS.md + agent configs |
| 7 | memory-setup | MemPalace with project-specific wings |
| 8 | pm-setup | CCPM + plans/docs directories |
| 9 | templates-scaffold | Project structure + starter files |
| 10 | workspace-setup | tmux config + IDE settings |

## Customization

### Create a new preset

```
presets/
└── my-preset/
    ├── preset.json       # Module config, directories, defaults
    ├── skills.json       # Skills to install
    ├── agents.json       # Agents to generate
    ├── standards/        # Code standard templates
    └── rules/            # CLAUDE.md rule templates
```

See [Presets documentation](docs/PRESETS.md) for the full spec.

### Add skills to the registry

Edit `registry/skills-sources.json` to add new skill sources:

```json
{
  "sources": {
    "your-org/your-skills": {
      "type": "github-plugin",
      "install": "/plugin marketplace add your-org/your-skills"
    }
  }
}
```

## Project structure

```
launchpad/
├── .claude/skills/launchpad/  - SKILL.md (entry point for /launch)
├── src/
│   ├── interview/             - Question sets and interview logic
│   ├── blueprint/             - Blueprint generator
│   ├── modules/               - 10 execution modules
│   └── verify/                - Health check
├── presets/                   - Project type presets
├── registry/                  - External source mappings
├── docs/                      - Documentation
└── install.sh                 - Installer script
```

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

## Credits

Built on top of:

- [Claude Code](https://claude.ai/code) - AI coding assistant by Anthropic
- [MemPalace](https://github.com/pchaganti/gx-mempalace) - Persistent memory system
- [CCPM](https://github.com/pchaganti/gx-ccpm) - Claude Code Project Manager
- [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) - Community skills
- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) - Agent skill collection

## License

MIT
