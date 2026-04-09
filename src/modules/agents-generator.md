# Module: agents-generator

Generate agent definition files from preset config.

## Input

- `preset.json`: modules.agents-generator.agents (list of {name, description})
- `project-context.json`: team_mode

## Confirmation

Show the user:
```
Agents to generate:
1. {name} - {description}
2. {name} - {description}
...
Team mode: {solo/agent-teams}
```

Ask: "Generate agent configs? (yes / skip / cancel)"

## Steps

1. Create agents directory:
   ```bash
   mkdir -p {project_path}/.claude/agents
   ```

2. For each agent in the preset config, generate `{project_path}/.claude/agents/{agent-name}.md`:

   ```markdown
   # {Agent Name}

   {description}

   ## Role

   You are the {agent_name} agent for this project.

   ## Responsibilities

   - (derived from description and project type)

   ## Tools

   - Read, Glob, Grep (all agents)
   - (additional tools based on agent role)

   ## Rules

   - Follow project code standards in docs/code-standards.md
   - Report findings in a structured format
   - Use the project's detected language for user-facing output
   ```

3. Generate AGENTS.md at project root:

   ```markdown
   # Agents

   | Agent | Description |
   |-------|-------------|
   | {name} | {description} |
   | ...   | ...         |

   ## Usage

   Agents are defined in `.claude/agents/` and can be invoked via the Agent tool.
   ```

4. If `team_mode == "agent-teams"`:
   - Add team coordination instructions to each agent
   - Include file ownership rules and communication protocol references

## Output

- `{project_path}/.claude/agents/{agent-name}.md` for each agent
- `{project_path}/AGENTS.md` with agent index

## Rollback

If generation fails:
1. Remove partially created agent files
2. If AGENTS.md was partially written, remove it
3. Report which agents failed so user can create manually
