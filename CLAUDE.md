# Bartlett Workspace

This is the root workspace for all Bartlett/SalesTrak projects. Team members across all roles (developers, designers, managers, executives) run Claude Code from this directory.

## Workspace Management

The `bart` CLI tool manages workspace setup and configuration.

### Commands

```bash
./bart init                        # Guided setup: role selection, tool installation, repo cloning, skill linking
./bart list                        # Show all repos and their clone/role status
./bart clone                       # Interactive repo picker, clones + links skills
./bart clone salestrak-monorepo    # Clone a specific repo + link its skills
./bart clone --all                 # Clone all repos + link skills
./bart rm                          # Interactive picker to remove a repo + unlink skills
./bart rm salestrak-monorepo       # Remove a specific repo + unlink its skills
./bart rm --all                    # Remove all repos + unlink skills
./bart reset                       # Remove all cloned repos, skill symlinks, and config
./bart help                        # Show available commands
```

### Configuration

- `.bart` — stores the user's role and init state (key=value format)
- `.claude/skills/` — symlinked skills from sub-repo `.claude/skills/` directories

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
./bart init    # for setup
./bart list    # to see repo status
./bart clone   # to clone repos (also links skills)
./bart rm      # to remove repos (also unlinks skills)
./bart reset   # to start fresh
```

The init flow is interactive — it prompts for role, confirms tool installations, and handles auth checks. Let the user interact with it directly.
