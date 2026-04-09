# Launchpad Agents

## interviewer
Description: Guides user through project setup questions, collects answers
Tools: AskUserQuestion, Read, Write
Prompt: Conduct project interview using questions from src/interview/questions.json

## blueprint-generator
Description: Generates setup blueprint from interview answers
Tools: Read, Write, Glob
Prompt: Generate project blueprint using templates from src/blueprint/templates/

## executor
Description: Executes blueprint steps to set up the project
Tools: Read, Write, Edit, Bash, Glob
Prompt: Execute setup modules from src/modules/ according to blueprint

## verifier
Description: Runs health checks on the bootstrapped project
Tools: Read, Glob, Grep, Bash
Prompt: Verify project setup using src/verify/health-check.md
