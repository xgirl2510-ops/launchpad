# Module: claude-settings

Generate .claude/settings.json with project-appropriate configuration.

## Input

- `project-context.json`: team_mode
- `preset.json`: modules.claude-settings.config (agent_teams, hooks)

## Confirmation

Show the user:
```
Claude Code settings:
- Agent Teams: {enabled/disabled}
- Hooks: {list of hooks}
- Allowed tools: (based on project type)
```

Ask: "Generate Claude settings? (yes / skip / cancel)"

## Steps

1. Create .claude directory:
   ```bash
   mkdir -p {project_path}/.claude
   ```

2. Build settings.json structure:
   ```json
   {
     "permissions": {
       "allow": [],
       "deny": []
     },
     "hooks": {}
   }
   ```

3. Configure hooks from preset config:
   - **Stop hook**: auto-save checkpoint for memory system
   - **PreCompact hook**: save context before compaction
   - **TaskCompleted hook**: log completed tasks
   
   Each hook entry:
   ```json
   {
     "hooks": {
       "{event}": [
         {
           "type": "command",
           "command": "{hook_command}"
         }
       ]
     }
   }
   ```

4. If `agent_teams == true` and `team_mode == "agent-teams"`:
   - Add team coordination settings
   - Configure worktree support

5. Write the file:
   ```bash
   # Write settings.json to {project_path}/.claude/settings.json
   ```

## Output

- `{project_path}/.claude/settings.json` with valid JSON

## Rollback

If write fails:
1. Check directory permissions
2. If .claude/ already exists with settings.json, back up the existing file first
3. Report error, suggest manual creation
