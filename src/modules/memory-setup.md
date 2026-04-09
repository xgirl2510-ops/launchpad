# Module: memory-setup

Install and initialize the MemPalace persistent memory system.

## Input

- `preset.json`: modules.memory-setup (system, wings)
- `project-context.json`: project_name, need_memory

## Confirmation

Show the user:
```
Memory system: MemPalace
Wings to create: {list of wings}
MCP server: will be registered in Claude settings
Hooks: stop hook for auto-save
```

Ask: "Set up MemPalace? (yes / skip / cancel)"

## Steps

1. Clone MemPalace repository:
   ```bash
   git clone https://github.com/pchaganti/gx-mempalace.git ~/.mempalace
   ```
   If already exists, skip clone and pull latest:
   ```bash
   cd ~/.mempalace && git pull
   ```

2. Run MemPalace install:
   ```bash
   cd ~/.mempalace && chmod +x install.sh && ./install.sh
   ```

3. Initialize the palace for this project:
   ```bash
   # MemPalace init creates the knowledge graph structure
   ```

4. Create wings from preset config:
   ```
   For each wing in wings list (e.g. game-design, art, levels, technical, bugs):
   - Create the wing in the palace structure
   ```

5. Register MemPalace MCP server in Claude settings:
   - Add MCP server config to `{project_path}/.claude/settings.json`:
   ```json
   {
     "mcpServers": {
       "mempalace": {
         "command": "node",
         "args": ["~/.mempalace/mcp-server/index.js"]
       }
     }
   }
   ```

6. Add auto-save hook to `.claude/settings.json`:
   ```json
   {
     "hooks": {
       "Stop": [{
         "type": "command",
         "command": "bash \"$HOME/.mempalace/hooks/mempal_save_hook.sh\""
       }]
     }
   }
   ```

7. Verify MemPalace is accessible:
   ```bash
   # Check MCP server can start without errors
   ```

## Output

- `~/.mempalace/` installed and initialized
- Palace wings created for the project
- MCP server registered in project Claude settings
- Auto-save hook configured

## Rollback

If installation fails:
1. If clone failed - check network, suggest manual install
2. If init failed - remove palace data, suggest retry
3. If MCP registration failed - settings.json remains valid, warn user to add manually
4. Never remove ~/.mempalace if it existed before this module ran
