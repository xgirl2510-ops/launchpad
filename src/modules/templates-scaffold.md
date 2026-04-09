# Module: templates-scaffold

Create project directory structure and starter files based on project type.

## Input

- `preset.json`: directories list, modules.templates-scaffold (structure)
- `project-context.json`: project_name, project_type, tech_stack

## Confirmation

Show the user:
```
Directories to create:
{list each directory from preset}

Starter files:
- README.md
- (type-specific starter files)
```

Ask: "Scaffold project structure? (yes / skip / cancel)"

## Steps

1. Create all directories from preset config:
   ```bash
   mkdir -p {project_path}/{directory}
   ```
   For each directory in `preset.json.directories`.

2. Add .gitkeep to empty directories so git tracks them:
   ```bash
   touch {project_path}/{directory}/.gitkeep
   ```

3. Generate README.md:
   ```markdown
   # {project_name}

   {description}

   ## Tech stack

   {tech_stack}

   ## Getting started

   (instructions based on project type)

   ## Project structure

   (generated from directories list)
   ```

4. Generate type-specific starter files:

   **unity-game**:
   - No code files (Unity generates these via the editor)
   - `Assets/Scripts/.gitkeep`

   **threejs-game**:
   - `src/main.ts` (basic Three.js setup)
   - `index.html` (entry point)
   - `package.json` (with three.js dependency)

   **saas-web**:
   - `src/app/page.tsx` (Next.js starter)
   - `src/app/layout.tsx` (root layout)
   - `package.json` (with Next.js dependencies)

   **api-service**:
   - `src/index.ts` (Express/Fastify entry)
   - `package.json` (with framework dependency)

   **custom**:
   - `README.md` only, no opinionated structure

5. Commit scaffolded structure:
   ```bash
   git add -A
   git commit -m "chore: scaffold project structure"
   ```

## Output

- All preset directories created
- README.md at project root
- Type-specific starter files
- Scaffold committed to git

## Rollback

If scaffolding fails:
1. Partially created directories are kept (still useful)
2. If commit fails - files remain staged, warn user to commit manually
3. Never overwrite existing files - skip and warn if a target file already exists
