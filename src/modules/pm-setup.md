# Module: pm-setup

Install and initialize the CCPM project management system.

## Input

- `preset.json`: modules.pm-setup (system)
- `project-context.json`: project_name, description, need_pm

## Confirmation

Show the user:
```
PM system: CCPM (Claude Code Project Manager)
Will create: plans/, plans/reports/, docs/ directories
Task tracking and sprint planning enabled
```

Ask: "Set up CCPM? (yes / skip / cancel)"

## Steps

1. Clone CCPM repository:
   ```bash
   git clone https://github.com/pchaganti/gx-ccpm.git ~/.ccpm
   ```
   If already exists, skip clone and pull latest:
   ```bash
   cd ~/.ccpm && git pull
   ```

2. Run CCPM install:
   ```bash
   cd ~/.ccpm && chmod +x install.sh && ./install.sh
   ```

3. Create project management directories:
   ```bash
   mkdir -p {project_path}/plans/reports
   mkdir -p {project_path}/docs
   ```

4. Initialize CCPM context for the project:
   - Create initial project context with name and description
   - Set up sprint tracking structure

5. Register CCPM hooks in `.claude/settings.json`:
   ```json
   {
     "hooks": {
       "TaskCompleted": [{
         "type": "command",
         "command": "bash \"$HOME/.ccpm/hooks/task_completed_hook.sh\""
       }]
     }
   }
   ```

6. Create initial docs structure:
   ```
   docs/
   ├── project-overview-pdr.md  (from project-context.json)
   └── code-standards.md        (placeholder, filled by code-standards module)
   ```

## Output

- `~/.ccpm/` installed and initialized
- `{project_path}/plans/` and `plans/reports/` directories created
- `{project_path}/docs/` directory with initial files
- CCPM hooks registered in Claude settings

## Rollback

If installation fails:
1. If clone failed - directories are still created, PM works manually without CCPM
2. If hook registration failed - settings.json remains valid, warn user
3. Created directories are kept (they are useful regardless of CCPM)
4. Never remove ~/.ccpm if it existed before this module ran
