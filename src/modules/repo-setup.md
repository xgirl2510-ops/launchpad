# Module: repo-setup

Initialize git repository and GitHub remote.

## Input

- `project-context.json`: project_name, repo_status, repo_visibility, repo_url
- `preset.json`: gitignore_template

## Confirmation

Show the user:
```
Repository setup:
- Action: {create new / clone existing}
- Name: {project_name}
- Visibility: {public/private}
- .gitignore: {gitignore_template}
```

Ask: "Proceed with repo setup? (yes / skip / cancel)"

## Steps

### If repo_status == "new"

1. Create the project directory if it does not exist:
   ```bash
   mkdir -p {project_path}
   cd {project_path}
   ```

2. Initialize git:
   ```bash
   git init
   ```

3. Generate .gitignore using the gitignore_template from preset:
   ```bash
   curl -sL "https://www.toptal.com/developers/gitignore/api/{gitignore_template}" > .gitignore
   ```
   If curl fails, create a minimal .gitignore for the project type.

4. Create initial commit:
   ```bash
   git add .gitignore
   git commit -m "chore: initial commit with .gitignore"
   ```

5. Create GitHub remote:
   ```bash
   gh repo create {project_name} --{visibility} --source=. --push
   ```

### If repo_status == "existing"

1. Clone the existing repo:
   ```bash
   git clone {repo_url} {project_path}
   cd {project_path}
   ```

2. Verify .gitignore exists. If not, generate one and commit:
   ```bash
   curl -sL "https://www.toptal.com/developers/gitignore/api/{gitignore_template}" > .gitignore
   git add .gitignore
   git commit -m "chore: add .gitignore"
   ```

## Output

- `{project_path}/.git/` initialized
- `{project_path}/.gitignore` exists
- GitHub remote configured and connected

## Rollback

If any step fails:
1. If `gh repo create` failed but git init succeeded - repo is still usable locally, warn user to create remote manually
2. If git init failed - remove the directory if it was just created, report error
3. Never force-delete an existing directory with user content
