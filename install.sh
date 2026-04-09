#!/usr/bin/env bash
# Launchpad installer - one-line setup for Claude Code projects
# Usage: curl -fsSL https://raw.githubusercontent.com/xgirl2510-ops/launchpad/main/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/xgirl2510-ops/launchpad.git"
INSTALL_DIR="$HOME/.launchpad"
SKILLS_DIR="$HOME/.claude/skills"
COMMANDS_DIR="$HOME/.claude/commands"
SKILL_NAME="launchpad"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[info]${NC} $1"; }
ok()    { echo -e "${GREEN}[ok]${NC} $1"; }
warn()  { echo -e "${YELLOW}[warn]${NC} $1"; }
fail()  { echo -e "${RED}[error]${NC} $1"; exit 1; }

# ------------------------------------------------------------------
# Phase 1: Check prerequisites
# ------------------------------------------------------------------
info "Checking prerequisites..."

missing=()

if ! command -v claude &>/dev/null; then
  missing+=("claude (Claude Code CLI - https://docs.anthropic.com/en/docs/claude-code)")
fi

if ! command -v gh &>/dev/null; then
  missing+=("gh (GitHub CLI - https://cli.github.com)")
fi

if ! command -v git &>/dev/null; then
  missing+=("git")
fi

if ! command -v tmux &>/dev/null; then
  missing+=("tmux (terminal multiplexer - brew install tmux)")
fi

if [ ${#missing[@]} -gt 0 ]; then
  echo ""
  fail "Missing required tools:\n$(printf '  - %s\n' "${missing[@]}")\n\nInstall them and re-run this script."
fi

ok "All prerequisites found"

# ------------------------------------------------------------------
# Phase 2: Clone or update repo
# ------------------------------------------------------------------
if [ -d "$INSTALL_DIR" ]; then
  info "Updating existing installation at $INSTALL_DIR..."
  git -C "$INSTALL_DIR" pull --ff-only || warn "Could not pull latest changes. Using existing version."
  ok "Updated"
else
  info "Cloning Launchpad to $INSTALL_DIR..."
  git clone "$REPO_URL" "$INSTALL_DIR"
  ok "Cloned"
fi

# ------------------------------------------------------------------
# Phase 3: Symlink skill into Claude Code
# ------------------------------------------------------------------
info "Setting up Claude Code skill..."

mkdir -p "$SKILLS_DIR"

SKILL_TARGET="$SKILLS_DIR/$SKILL_NAME"

if [ -L "$SKILL_TARGET" ]; then
  rm "$SKILL_TARGET"
elif [ -d "$SKILL_TARGET" ]; then
  warn "Directory $SKILL_TARGET already exists (not a symlink). Backing up to ${SKILL_TARGET}.bak"
  mv "$SKILL_TARGET" "${SKILL_TARGET}.bak"
fi

ln -s "$INSTALL_DIR/.claude/skills/$SKILL_NAME" "$SKILL_TARGET"
ok "Skill symlinked: $SKILL_TARGET -> $INSTALL_DIR/.claude/skills/$SKILL_NAME"

# ------------------------------------------------------------------
# Phase 4: Create slash command /launch
# ------------------------------------------------------------------
info "Creating /launch slash command..."

mkdir -p "$COMMANDS_DIR"

COMMAND_FILE="$COMMANDS_DIR/launch.md"

cat > "$COMMAND_FILE" << 'COMMAND_EOF'
# /launch - Bootstrap a new AI-first project with Launchpad

Activate the `launchpad` skill and run the full bootstrapping flow:

1. Interview - Collect project information
2. Blueprint - Generate setup plan
3. Review - User approves the plan
4. Execute - Run setup modules
5. Verify - Health check the result

Start by reading `~/.launchpad/.claude/skills/launchpad/SKILL.md` for context, then begin the interview phase using `~/.launchpad/src/interview/questions.json`.
COMMAND_EOF

ok "Slash command created: /launch"

# ------------------------------------------------------------------
# Done
# ------------------------------------------------------------------
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Launchpad installed successfully!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "  Installation directory:  ${CYAN}$INSTALL_DIR${NC}"
echo -e "  Skill location:          ${CYAN}$SKILL_TARGET${NC}"
echo -e "  Slash command:           ${CYAN}/launch${NC}"
echo ""
echo -e "  ${YELLOW}How to use:${NC}"
echo -e "  1. Open Claude Code in any directory"
echo -e "  2. Type ${CYAN}/launch${NC} to start bootstrapping a new project"
echo -e "  3. Answer the interview questions"
echo -e "  4. Review and approve the generated blueprint"
echo -e "  5. Launchpad sets up your project automatically"
echo ""
echo -e "  ${YELLOW}To update:${NC}  re-run this installer"
echo -e "  ${YELLOW}To remove:${NC}  rm -rf ~/.launchpad ~/.claude/skills/launchpad ~/.claude/commands/launch.md"
echo ""
