# Module: code-standards

Install code standards and linting configuration from preset.

## Input

- `preset.json`: modules.code-standards (files list)
- Preset standards directory: `presets/{project_type}/standards/`

## Confirmation

Show the user:
```
Code standards to install:
1. {filename} - {brief description}
2. {filename} - {brief description}
Also creating: .editorconfig
```

Ask: "Install code standards? (yes / skip / cancel)"

## Steps

1. Ensure docs directory exists:
   ```bash
   mkdir -p {project_path}/docs
   ```

2. Copy each standards file from preset to project docs:
   ```bash
   cp ~/.launchpad/presets/{project_type}/standards/{filename} {project_path}/docs/{filename}
   ```
   For each file listed in `modules.code-standards.files`.

3. Generate `.editorconfig` at project root:
   ```ini
   root = true

   [*]
   indent_style = space
   indent_size = 2
   end_of_line = lf
   charset = utf-8
   trim_trailing_whitespace = true
   insert_final_newline = true

   [*.md]
   trim_trailing_whitespace = false

   [*.{cs,shader}]
   indent_size = 4
   ```
   Adjust indent rules based on project type:
   - Unity/C#: indent_size = 4 for .cs files
   - Web/JS/TS: indent_size = 2
   - Python: indent_size = 4 for .py files

4. If project type uses linting tools, create basic lint config:
   - **saas-web / api-service**: `.eslintrc.json` or `eslint.config.js` stub
   - **unity-game**: `.editorconfig` is sufficient (Unity uses Roslyn analyzers)
   - **threejs-game**: `.eslintrc.json` stub
   - **custom**: `.editorconfig` only

## Output

- `{project_path}/docs/{standards-file}.md` for each standards file
- `{project_path}/.editorconfig`
- Lint config file if applicable

## Rollback

If copy fails:
1. Check if source standards files exist in preset
2. If a file is missing from preset, generate a minimal placeholder and warn user
3. .editorconfig failure is non-critical - warn and continue
