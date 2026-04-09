# Module: code-standards

Generate and install code standards, best practices, and linting configuration tailored to the project's tech stack.

## Input

- `project-context.json`: primary_language, framework, database, additional_tools, code_style
- `preset.json`: modules.code-standards (files list)
- Preset standards directory: `presets/{project_type}/standards/`

## Confirmation

Show the user:
```
Code standards generation:
- Language: {primary_language}
- Framework: {framework}
- Style: {code_style or "auto (best practices)"}

Will generate:
1. docs/code-standards.md         - Naming, structure, patterns for {primary_language}
2. docs/code-checklist.md         - Pre-commit checklist
3. docs/clean-code-principles.md  - Clean code rules for {primary_language}
4. .editorconfig                  - Editor formatting rules

Also copying preset standards (if any):
{list preset standard files}
```

Ask: "Generate code standards? (yes / skip / cancel)"

## Steps

### Step 1: Copy preset standards

If the preset has standards files in `presets/{project_type}/standards/`:

```bash
mkdir -p {project_path}/docs
cp ~/.launchpad/presets/{project_type}/standards/*.md {project_path}/docs/
```

These serve as a base. The generated files below supplement or override them.

### Step 2: Generate docs/code-standards.md

Research and generate a comprehensive code standards file specific to `primary_language` and `framework`. Must include:

- **Naming conventions** - variables, functions, classes, files, directories
- **File structure** - how to organize code files, max lines per file (200)
- **Import/export patterns** - ESM vs CJS, module organization
- **Type system** - type annotations, generics, interfaces (if applicable)
- **Error handling** - try/catch patterns, custom errors, error propagation
- **Async patterns** - promises, async/await, coroutines (language-specific)
- **State management** - where state lives, how it flows
- **API patterns** - request/response, validation, serialization

If `code_style` is specified (e.g. "Airbnb", "Google", "Microsoft"), follow that convention. If "auto" or empty, use the most widely adopted convention for the language.

Language-specific sections:

| Language | Key sections |
|----------|-------------|
| C# | Namespace conventions, Unity MonoBehaviour lifecycle, ScriptableObject usage, SOLID in Unity |
| TypeScript | Strict mode, type narrowing, discriminated unions, Zod validation |
| Python | PEP 8, type hints, dataclasses, context managers |
| Rust | Ownership patterns, error handling with Result/Option, trait design |
| Go | Package naming, error wrapping, interface design, goroutine patterns |

### Step 3: Generate docs/code-checklist.md

A pre-commit/pre-review checklist:

```markdown
# Code Checklist

## Before every commit
- [ ] No hardcoded secrets, API keys, or credentials
- [ ] No console.log / print / Debug.Log left in production code
- [ ] All new functions have clear, descriptive names
- [ ] Error cases handled (not silently swallowed)
- [ ] No unused imports or dead code
- [ ] File under 200 lines (split if larger)

## {primary_language}-specific
- [ ] (language-specific items based on primary_language)

## {framework}-specific
- [ ] (framework-specific items based on framework)
```

### Step 4: Generate docs/clean-code-principles.md

Clean code rules tailored to the language:

- **Single responsibility** - one function = one job, examples in {primary_language}
- **DRY** - extract shared logic, but avoid premature abstraction
- **YAGNI** - do not build for hypothetical futures
- **KISS** - simplest working solution first
- **Naming** - code should read like prose, examples in {primary_language}
- **Functions** - max 20 lines preferred, max 3 parameters
- **Comments** - only when "why" is not obvious from code
- **Testing** - what to test, what not to test, naming conventions

Include code examples in `primary_language` for each principle (good vs bad).

### Step 5: Generate .editorconfig

```ini
root = true

[*]
indent_style = space
indent_size = {2 for JS/TS, 4 for C#/Python/Rust/Go}
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false

[*.{language_extensions}]
indent_size = {language_default}
```

### Step 6: Generate lint config (if applicable)

| Stack | Config file | Content |
|-------|-------------|---------|
| TypeScript/JS | `eslint.config.js` | ESM flat config with recommended rules |
| Python | `pyproject.toml` (ruff section) | Ruff linter config |
| C# | `.editorconfig` | Roslyn analyzer rules (already covered) |
| Rust | `rustfmt.toml` | Format config |
| Go | `.golangci.yml` | GolangCI-Lint config |

## Output

- `{project_path}/docs/code-standards.md` - language and framework conventions
- `{project_path}/docs/code-checklist.md` - pre-commit checklist
- `{project_path}/docs/clean-code-principles.md` - clean code rules with examples
- `{project_path}/.editorconfig` - editor formatting
- Lint config file (if applicable)
- Preset standard files copied to docs/ (if any)

## Rollback

If generation fails:
1. Preset standards are still copied as fallback
2. If a generated file fails, keep partial content and warn user
3. .editorconfig and lint config failures are non-critical - warn and continue
