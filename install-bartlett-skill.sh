#!/bin/bash

# Bartlett Setup Skill Installer
# This script installs the bartlett-setup skill globally for Claude Code

set -e

SKILL_DIR="$HOME/.claude/skills/bartlett-workspace"

echo "Installing Bartlett Setup skill for Claude Code..."

# Create skill directory
mkdir -p "$SKILL_DIR"

# Create SKILL.md
cat > "$SKILL_DIR/SKILL.md" << 'EOF'
---
name: bartlett-setup
description: Set up or manage the Bartlett/SalesTrak workspace using the bart CLI tool. Use when user asks to setup bartlett workspace, initialize bartlett, or setup their workspace for SalesTrak development.
tools: Bash, Read, AskUserQuestion
---

# Bartlett Workspace Setup

You are helping set up the Bartlett/SalesTrak workspace using the `bart` CLI tool.

## Setup Process

The bart tool handles workspace setup automatically. Ask the user these configuration questions BEFORE running bart init:

### 1. Role Selection
Ask which role they have:
- **developer** — Full access (all 3 repos)
- **designer** — Design-focused (component library + prototypes)
- **manager** — Component library only
- **executive** — Component library only

Use AskUserQuestion with these exact options.

### 2. Workspace Location
Ask where they want their workspace:
- Default: `~/bartlett-workspace`
- Or custom path

### 3. Run bart init

Once you have their preferences, run bart init with environment variables:

```bash
BART_ROLE=<role> BART_WORKSPACE=<path> ./bart init
```

Example:
```bash
BART_ROLE=developer BART_WORKSPACE=~/bartlett-workspace ./bart init
```

## What bart init does automatically

The script will automatically:
1. Install bart to `~/.bart/bart` (if not already installed)
2. Add `~/.bart` to PATH in shell config
3. Create workspace directory at specified location
4. Save `BART_ROOT` to `~/.bart/config`
5. Set the selected role in workspace config
6. Check/install prerequisites (git, pnpm, gh, claude)
7. Verify GitHub authentication
8. Check Claude Code authentication
9. Download CLAUDE.md and .claude directory from GitHub
10. Clone repositories based on role
11. Link Claude skills from each repo

## Prerequisites Check

The script checks for and offers to install:
- **git** — Version control
- **pnpm** — Package manager
- **gh** — GitHub CLI (for cloning repos)
- **claude** — Claude Code CLI

If any are missing, bart will attempt to install them via brew.

## GitHub & Claude Authentication

- **GitHub**: Must be authenticated with `gh auth login` before running
- **Claude Code**: Will warn if not authenticated but continue anyway

## Other bart commands

After setup, users can run:
- `bart update` — Check for and install updates from GitHub
- `bart list` — Show all repos and their clone status
- `bart clone [repo]` — Clone additional repos
- `bart rm [repo]` — Remove repos
- `bart reset` — Remove all repos, symlinks, and config
- `bart claude` — Launch Claude Code in the workspace
- `bart uninstall` — Remove bart from system
- `bart help` — Show all commands

## Your workflow

1. **Check if bart exists** in current directory:
   ```bash
   ls -la bart
   ```

2. **If bart doesn't exist**, ask if they want to install it:
   - Remote: `curl -fsSL https://raw.githubusercontent.com/SalesTrak/bartlett-workspace/main/install.sh | bash`
   - Then download bart or guide them to clone the repo

3. **Ask configuration questions** using AskUserQuestion:
   - Role selection (developer/designer/manager/executive)
   - Workspace path (default: ~/bartlett-workspace)

4. **Run bart init** with their preferences:
   ```bash
   BART_ROLE=<role> BART_WORKSPACE=<path> ./bart init
   ```

5. **Confirm success** and inform them:
   - Workspace location
   - Which repos were cloned
   - How to launch Claude Code: `bart claude` or `cd <workspace> && claude`

Be conversational and helpful. Let the user know what's happening at each step.
EOF

echo ""
echo "✅ Bartlett Setup skill installed successfully!"
echo ""
echo "Location: $SKILL_DIR/SKILL.md"
echo ""
echo "Restart Claude Code, then you can use this skill by saying:"
echo "  • 'setup bartlett workspace'"
echo "  • 'initialize bartlett'"
echo "  • '/bartlett-setup'"
echo ""
