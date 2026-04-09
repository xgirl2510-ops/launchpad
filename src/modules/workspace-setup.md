# Module: workspace-setup

Configure tmux workspace and startup script for the development environment.

## Input

- `preset.json`: modules.workspace-setup (tmux)
- `project-context.json`: project_name, project_type

## Confirmation

Show the user:
```
Workspace setup:
- tmux config: {yes/no}
- Startup script: .claude/launchpad/start.sh
- IDE settings: (based on project type)
```

Ask: "Configure workspace? (yes / skip / cancel)"

## Steps

1. Create launchpad directory in project:
   ```bash
   mkdir -p {project_path}/.claude/launchpad
   ```

2. If `tmux == true`, generate tmux startup script at `.claude/launchpad/start.sh`:
   ```bash
   #!/bin/bash
   # Launchpad workspace startup for {project_name}
   SESSION="{project_name}"

   # Kill existing session if any
   tmux kill-session -t "$SESSION" 2>/dev/null

   # Create new session
   tmux new-session -d -s "$SESSION" -n "code"

   # Window 1: Main coding (Claude Code)
   tmux send-keys -t "$SESSION:code" "cd {project_path} && claude" Enter

   # Window 2: Git / commands
   tmux new-window -t "$SESSION" -n "git"
   tmux send-keys -t "$SESSION:git" "cd {project_path}" Enter

   # Window 3: Server / build (if applicable)
   tmux new-window -t "$SESSION" -n "server"
   tmux send-keys -t "$SESSION:server" "cd {project_path}" Enter

   # Attach to session
   tmux attach -t "$SESSION"
   ```

3. Make startup script executable:
   ```bash
   chmod +x {project_path}/.claude/launchpad/start.sh
   ```

4. Generate IDE settings if applicable:

   **VS Code** (saas-web, api-service, threejs-game):
   ```bash
   mkdir -p {project_path}/.vscode
   ```
   Create `.vscode/settings.json`:
   ```json
   {
     "editor.formatOnSave": true,
     "editor.defaultFormatter": "esbenp.prettier-vscode",
     "typescript.preferences.importModuleSpecifier": "relative"
   }
   ```

   **Unity** (unity-game):
   - Skip .vscode (Unity manages its own IDE settings via .csproj)

5. Generate `.env.example` if project type uses environment variables (saas-web, api-service):
   ```
   # {project_name} environment variables
   # Copy this file to .env and fill in the values

   NODE_ENV=development
   PORT=3000
   DATABASE_URL=
   ```

## Output

- `{project_path}/.claude/launchpad/start.sh` (tmux startup)
- `{project_path}/.vscode/settings.json` (if applicable)
- `{project_path}/.env.example` (if applicable)

## Rollback

If setup fails:
1. Missing tmux is non-fatal - skip tmux config, warn user to install tmux
2. IDE settings failure is non-critical - warn and continue
3. Never overwrite existing .vscode/settings.json or .env - skip and warn
