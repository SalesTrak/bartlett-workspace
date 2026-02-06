# Bartlett Workspace

This is the root workspace for all Bartlett/SalesTrak projects. Team members across all roles (developers, designers, managers, executives) run Claude Code from this directory.

## Workspace Management

The `bart` CLI tool manages workspace setup and configuration.

### Installation

**Option 1: Remote install (recommended for new users)**
```bash
curl -fsSL https://raw.githubusercontent.com/SalesTrak/bartlett-workspace/main/install.sh | bash
bart init
```

**Option 2: Local install (for development)**
```bash
./bart init       # Does everything in one command
```

The **install.sh script**:
- Creates `~/.bart` directory
- Downloads `bart` to `~/.bart/bart`
- Detects your shell and adds `~/.bart` to PATH
- Prompts you to run `bart init` next

The **bart init command**:
- Offers to install bart to `~/.bart` (if not already installed)
- Adds `~/.bart` to your shell PATH (if needed)
- Prompts for workspace directory location (default: `~/bartlett-workspace`)
- Creates the workspace directory
- Saves `BART_ROOT` to `~/.bart/config`
- Guides through role selection, tool installation, and repo cloning

### Commands

```bash
bart init                        # Install bart globally (if needed) + guided setup: role, tools, repos, skills
bart update                      # Check for and install updates from GitHub
bart update --force              # Force update (skip timestamp checks)
bart list                        # Show all repos and their clone/role status
bart clone                       # Interactive repo picker, clones + links skills
bart clone salestrak-monorepo    # Clone a specific repo + link its skills
bart clone --all                 # Clone all repos + link skills
bart rm                          # Interactive picker to remove a repo + unlink skills
bart rm salestrak-monorepo       # Remove a specific repo + unlink its skills
bart rm --all                    # Remove all repos + unlink skills
bart reset                       # Remove all cloned repos, skill symlinks, and config
bart claude                      # Launch Claude Code in the workspace directory
bart uninstall                   # Remove bart from ~/.bart and PATH
bart help                        # Show available commands
```

### Configuration

- `~/.bart/` — global bart installation directory (created by install.sh or bart install)
- `~/.bart/bart` — the bart CLI executable
- `~/.bart/config` — stores `BART_ROOT` path to workspace (created by bart init)
- `<workspace>/.bart` — stores the user's role and init state (key=value format)
- `<workspace>/.claude/skills/` — symlinked skills from sub-repo `.claude/skills/` directories

## Repositories

| Repo | Directory | Description |
|------|-----------|-------------|
| SalesTrak/salestrak-monorepo | `salestrak-monorepo/` | Monorepo for the SalesTrak app (API + frontend) |
| SalesTrak/bartlett-component-library | `bartlett-component-library/` | Shared React Native UI component library |
| SalesTrak/design-prototypes | `design-prototypes/` | Designer playground with Storybook |

### Role-Based Access

| Role | Repos |
|------|-------|
| developer | all three |
| designer | bartlett-component-library, design-prototypes |
| manager | bartlett-component-library |
| executive | bartlett-component-library |

## Running bart

When a user asks to set up their workspace, initialize, or reset, run the `bart` CLI:

```bash
./bart init         # first time - install bart globally + set up workspace
bart update         # check for updates from GitHub
bart update --force # force update (skip timestamp checks)
bart list           # to see repo status
bart clone          # to clone repos (also links skills)
bart rm             # to remove repos (also unlinks skills)
bart reset          # to start fresh
bart claude         # launch Claude Code in workspace
```

The init flow is interactive — it offers to install bart globally, prompts for workspace location and role, confirms tool installations, and handles auth checks. Let the user interact with it directly.
