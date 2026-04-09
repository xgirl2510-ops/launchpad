# CLAUDE.md Template — Unity Game

## Project: {{project_name}}
{{description}}

## Tech Stack
- Unity {{unity_version}}
- Render Pipeline: {{render_pipeline}}
- Language: C#

## Architecture
- Follow Unity code standards in `docs/unity-code-standards.md`
- Use ScriptableObjects for data/config
- Composition over inheritance
- Event-driven communication between systems

## File Organization
- `Assets/Scripts/` — all C# scripts
- `Assets/Prefabs/` — prefab assets
- `Assets/Scenes/` — scene files
- `Assets/UI/` — UI assets and layouts
- `docs/` — project documentation
- `plans/` — development plans

## Rules
- Keep scripts under 200 lines
- Cache component references
- Use object pooling
- No runtime Find/GetComponent in Update
