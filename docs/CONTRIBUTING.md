# Contributing

## Adding a New Preset
1. Create directory under `presets/{preset-name}/`
2. Add `preset.json`, `skills.json`, `agents.json`
3. Add standards files under `standards/`
4. Add CLAUDE.md template under `rules/`
5. Update `docs/PRESETS.md`

## Adding a New Module
1. Create module file under `src/modules/{module-name}.md`
2. Document purpose, steps, inputs, and outputs
3. Add module to relevant preset configs

## Code Standards
- Follow YAGNI/KISS/DRY
- Keep files under 200 lines
- Use kebab-case file naming
- Test your changes before submitting
