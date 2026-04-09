# Launchpad

AI-first project bootstrapper for Claude Code.

## Trigger

Activate this skill when:
- User runs `/launch`
- User says "bootstrap project", "init project", "setup project", "new project"
- User says "khởi tạo dự án", "tạo dự án mới", "setup dự án"

## Important paths

All paths below are relative to the Launchpad installation directory (`~/.launchpad/`):

- Questions: `src/interview/questions.json`
- Blueprint generator: `src/blueprint/generator.md`
- Blueprint templates: `src/blueprint/templates/`
- Execution modules: `src/modules/`
- Health check: `src/verify/health-check.md`
- Presets: `presets/`
- Registry: `registry/`

## Execution flow

Follow these phases strictly in order. Do NOT skip phases. Do NOT proceed to the next phase without explicit user confirmation.

---

### Phase 1: Interview

**Goal:** Collect all information needed to generate a setup blueprint.

**Steps:**

1. Read `src/interview/questions.json` to load the question sets
2. Detect the user's language from their initial message. Use that language for all prompts and output going forward
3. Ask the **common** questions one by one:
   - `project_name` (required) - name for the project and GitHub repo
   - `project_type` (required) - one of: unity-game, threejs-game, saas-web, api-service, custom
   - `description` (required) - brief project description
   - `tech_stack` (optional) - primary tech stack and frameworks
   - `team_size` (optional) - solo / small / medium / large
   - `repo_visibility` (required) - public / private
   - `extra_skills` (optional) - additional skills to install
4. After `project_type` is answered, load the matching **per_type** questions from `questions.json` and ask those too
5. For `select` type questions, present the options clearly. For `text` type, accept free-form input
6. Skip optional questions if the user says "skip" or provides no answer
7. After all questions are answered, display a summary table of all collected answers
8. Ask the user to confirm the answers are correct. If not, let them edit specific answers

**Output:** A structured answers object with all collected data. Store mentally for Phase 2.

---

### Phase 2: Blueprint generation

**Goal:** Generate a step-by-step setup plan from the answers.

**Steps:**

1. Read the matching preset from `presets/{project_type}/preset.json`
2. Read `presets/{project_type}/skills.json` for the skills list
3. Read `presets/{project_type}/agents.json` for the agents list
4. Read `src/blueprint/generator.md` for the blueprint generation rules
5. Merge preset defaults with user answers (user answers override preset defaults)
6. If `extra_skills` were provided, append them to the skills list from the preset
7. Generate the blueprint - an ordered list of modules to execute:

```
Module execution order:
1. repo-setup        - Initialize git repo and GitHub remote
2. claude-settings   - Generate .claude/settings.json
3. rules-generator   - Generate CLAUDE.md with project rules
4. code-standards    - Install code standards from preset
5. skills-installer  - Install skills from registry
6. agents-generator  - Generate AGENTS.md and agent configs
7. memory-setup      - Initialize Claude Code memory system
8. pm-setup          - Create plans/ and docs/ directories
9. templates-scaffold - Scaffold project files and structure
10. workspace-setup  - Configure IDE and dev environment
```

8. For each module, include the specific config derived from the answers (project name, tech stack, skills list, agents list, etc.)

**Output:** The complete blueprint with all modules and their configs.

---

### Phase 3: Blueprint review

**Goal:** Get user approval before executing anything.

**Steps:**

1. Display the blueprint in a clear, readable format:
   - Project name, type, tech stack
   - List of modules to execute (numbered)
   - For each module: what it will do and what it will create
   - Skills to install (with names)
   - Agents to generate (with names and descriptions)
2. Ask the user: "Approve this blueprint? (yes / edit / cancel)"
   - **yes** - proceed to Phase 4
   - **edit** - ask what to change, update the blueprint, show again
   - **cancel** - abort the entire process

Do NOT proceed without explicit "yes" or approval.

---

### Phase 4: Module execution

**Goal:** Execute each module in order to set up the project.

**Steps:**

For each module in the blueprint:

1. Announce which module is about to run (e.g., "Module 1/10: Repository Setup")
2. Read the module instructions from `src/modules/{module-name}.md`
3. Show the user what this module will do and what files it will create/modify
4. Ask for confirmation: "Run this module? (yes / skip / cancel)"
   - **yes** - execute the module
   - **skip** - skip this module, move to next
   - **cancel** - stop execution (already-completed modules remain)
5. Execute the module according to its instructions
6. Report what was created/modified
7. Move to the next module

**Module details:**

| Module | Reads from | Creates |
|--------|-----------|---------|
| repo-setup | preset.json | .gitignore, git init, gh repo create |
| claude-settings | preset.json | .claude/settings.json |
| rules-generator | preset rules/ | CLAUDE.md |
| code-standards | preset standards/ | docs/code-standards.md |
| skills-installer | skills.json, registry/ | .claude/skills/* |
| agents-generator | agents.json | AGENTS.md, .claude/agents/* |
| memory-setup | answers | ~/.claude/projects/.../memory/ |
| pm-setup | preset.json | plans/, plans/reports/, docs/ |
| templates-scaffold | preset.json, answers | Project source directories and starter files |
| workspace-setup | preset.json | .vscode/, .env.example |

---

### Phase 5: Health check

**Goal:** Verify the project was set up correctly.

**Steps:**

1. Read `src/verify/health-check.md` for the check list
2. Run each check:
   - Git repo initialized and remote configured
   - .gitignore exists
   - CLAUDE.md exists at project root with project overview
   - .claude/settings.json exists and is valid JSON
   - All requested skills installed with SKILL.md present
   - AGENTS.md exists with valid agent definitions
   - docs/ directory exists
   - plans/ and plans/reports/ directories exist
   - Code standards file present in docs/
3. Display results as a checklist with pass/fail per item
4. Calculate overall health score (passed / total checks)
5. If any checks failed, suggest how to fix them
6. End with a summary message confirming the project is ready

---

## Rules

- Never execute destructive operations without user confirmation
- If a module fails, report the error and ask the user whether to retry, skip, or cancel
- Detect user language from their first message and use it consistently throughout all phases
- All generated files in the target project follow the rules defined in the target CLAUDE.md (which is generated during execution)
- If the target directory already has a CLAUDE.md or .claude/ folder, warn the user before overwriting
