# Interviewer

Instructions for Claude Code to conduct the project setup interview.

## Prerequisites

- Read `src/interview/questions.json` to load all phases and questions
- Detect the user's language from their first message
- Use detected language for all prompts, confirmations, and summaries

## Flow

### Step 1: Greeting

Greet the user and introduce Launchpad briefly:

> Launchpad - AI-first project bootstrapper for Claude Code.
> I will ask a few questions to set up your project. You can type "skip" for optional questions.

### Step 2: Iterate phases

For each phase in `questions.json`:

1. Announce the phase title (translated to user's language)
2. Ask each question in order within the phase

### Step 3: Ask each question

For each question:

1. **Check condition** - if the question has a `condition` field (e.g. `repo_status == existing`), evaluate it against collected answers. Skip the question silently if condition is not met
2. **Present the question** - translate to user's language. Include:
   - The question text
   - `[required]` tag if `required: true`
   - Available options if `type: select` (numbered list)
   - Default value if `type: boolean` (e.g. "default: yes")
   - Hint text if `hint` exists
3. **Accept answer** - store the answer keyed by question `id`
4. **Handle `review-and-add` type** - when the question type is `review-and-add`:
   a. Read the source file (e.g. `presets/{project_type}/skills.json` or `agents.json`)
   b. Display the preset list to the user (numbered, with descriptions if available)
   c. Ask: "Want to add more? (type names, or skip)"
   d. Store result as: `{"preset": [...from file], "added": [...user additions]}`
5. **Validate** - if `required: true` and answer is empty, ask again

### Step 4: Allow edits

After all phases are complete:

1. Display a summary table of all collected answers:
   ```
   | Field             | Value              |
   |-------------------|--------------------|
   | project_name      | my-app             |
   | project_type      | saas-web           |
   | ...               | ...                |
   ```
2. Ask: "Everything correct? (yes / edit)"
3. If **edit** - ask which field to change by `id`, accept new value, show updated table, ask again
4. If **yes** - proceed to Step 5

### Step 5: Generate project-context.json

Create `project-context.json` at the target project directory with this structure:

```json
{
  "project_name": "...",
  "project_type": "...",
  "description": "...",
  "repo_status": "new",
  "repo_visibility": "public",
  "primary_language": "...",
  "framework": "...",
  "database": "...",
  "additional_tools": "...",
  "code_style": "...",
  "team_mode": "agent-teams",
  "need_pm": true,      // derived: "ccpm" in features[]
  "need_memory": true,  // derived: "mempalace" in features[]
  "skills": {"preset": ["...from preset"], "added": ["...user extras"]},
  "agents": {"preset": [{"name": "...", "description": "..."}], "added": ["...user extras"]},
  "created_at": "2026-04-09T14:55:00+07:00",
  "launchpad_version": "0.1.0"
}
```

Only include fields that were answered (skip fields the user skipped).

The `tech_stack` phase answers (`primary_language`, `framework`, `database`, `additional_tools`, `code_style`) are critical - the code-standards module uses them to auto-generate language-specific standards, checklist, and clean code principles.

### Step 6: Final confirmation

Display the complete project context summary and ask:

"Confirm and proceed to blueprint generation? (yes / edit / cancel)"

- **yes** - hand off to Phase 2 (blueprint generation) per SKILL.md
- **edit** - go back to Step 4
- **cancel** - abort, delete project-context.json if created

## Rules

- Never assume answers. Always ask
- Respect the question order defined in questions.json
- Translate all user-facing text to the detected language
- Keep prompts concise - one question at a time, no walls of text
- If user provides multiple answers in one message, accept them all and move forward
- If user answers in a different language mid-interview, switch to that language
