# Module: rules-generator

Generate CLAUDE.md and AGENTS.md from preset templates and project context.

## Input

- `preset.json`: modules.rules-generator (template path)
- Preset rules directory: `presets/{project_type}/rules/`
- `project-context.json`: all fields

## Confirmation

Show the user:
```
Will generate:
- CLAUDE.md (project rules and instructions for Claude Code)
- Template: {template file from preset}
- Includes: project overview, code conventions, architecture, workflows
```

Ask: "Generate project rules? (yes / skip / cancel)"

## Steps

1. Read the rules template from preset:
   ```bash
   cat ~/.launchpad/presets/{project_type}/rules/{template_file}
   ```

2. Build CLAUDE.md by combining:

   a. **Project header**:
      ```markdown
      # CLAUDE.md - {project_name}

      ## Project overview

      {description}
      - Type: {project_type}
      - Stack: {tech_stack}
      ```

   b. **Preset rules** (from template file):
      - Code conventions specific to the project type
      - Architecture patterns
      - File naming rules

   c. **Dynamic sections** (from project-context.json):
      - If `need_pm == true`: add PM workflow section
      - If `need_memory == true`: add memory system instructions
      - If `team_mode == "agent-teams"`: add team coordination rules

   d. **Standard sections** (always included):
      - Language rules (code in English, docs detect user language)
      - Development workflow (read CLAUDE.md first, check structure, etc.)
      - Commit message conventions

3. Write CLAUDE.md:
   ```bash
   # Write to {project_path}/CLAUDE.md
   ```

4. Verify CLAUDE.md is valid markdown and under 200 lines.
   If over 200 lines, split into CLAUDE.md (overview + key rules) with references to docs/ files.

## Output

- `{project_path}/CLAUDE.md` with complete project rules

## Rollback

If generation fails:
1. If template file missing - generate minimal CLAUDE.md with project overview only
2. If write fails - check permissions, suggest manual creation
3. If existing CLAUDE.md found - back it up as CLAUDE.md.bak before overwriting
