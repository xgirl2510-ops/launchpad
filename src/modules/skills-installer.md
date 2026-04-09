# Module: skills-installer

Install skills from registry sources into the project.

## Input

- `preset.json`: modules.skills-installer.skills (list of {name, source})
- `project-context.json`: additional_skills
- `registry/skills-sources.json`: source URL mappings

## Confirmation

Show the user:
```
Skills to install:
1. {skill_name} (from {source})
2. {skill_name} (from {source})
...
+ User requested: {additional_skills}
```

Ask: "Install these skills? (yes / skip / cancel)"

## Steps

1. Read `~/.launchpad/registry/skills-sources.json` to resolve source URLs

2. For each skill in the combined list (preset + user additional):

   a. Resolve the source - determine the GitHub repo and skill path:
      ```
      source: "alirezarezvani/claude-skills" -> https://github.com/alirezarezvani/claude-skills
      skill path: skills/{skill_name}/
      ```

   b. Download the skill files:
      ```bash
      # Clone source repo to temp directory
      git clone --depth 1 --filter=blob:none --sparse {repo_url} /tmp/launchpad-skill-{skill_name}
      cd /tmp/launchpad-skill-{skill_name}
      git sparse-checkout set skills/{skill_name}
      ```

   c. Copy to project:
      ```bash
      cp -r /tmp/launchpad-skill-{skill_name}/skills/{skill_name} {project_path}/.claude/skills/{skill_name}
      ```

   d. Cleanup temp:
      ```bash
      rm -rf /tmp/launchpad-skill-{skill_name}
      ```

   e. Verify SKILL.md exists:
      ```bash
      test -f {project_path}/.claude/skills/{skill_name}/SKILL.md
      ```

3. Report installed skills count and any failures

## Output

- `{project_path}/.claude/skills/{skill_name}/SKILL.md` for each skill
- Associated scripts and references within each skill directory

## Rollback

If a skill fails to install:
1. Remove the partially copied skill directory
2. Log the failure but continue with remaining skills
3. Report all failures at the end so user can install manually
