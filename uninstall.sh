#!/usr/bin/env bash
set -euo pipefail

# ── Bartlett Workspace Uninstaller ───────────────────────────────────────────
# Usage: ./uninstall.sh

BART_HOME="${HOME}/.bart"
BART_CONFIG="${BART_HOME}/config"

# Colors (if terminal supports them)
if [ -t 1 ]; then
  BOLD='\033[1m'
  CYAN='\033[0;36m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  DIM='\033[2m'
  RESET='\033[0m'
else
  BOLD='' CYAN='' GREEN='' YELLOW='' RED='' DIM='' RESET=''
fi

info()    { printf "  ${CYAN}>${RESET} %s\n" "$1"; }
success() { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
warn()    { printf "  ${YELLOW}!${RESET} %s\n" "$1"; }
error()   { printf "  ${RED}✗${RESET} %s\n" "$1"; }
header()  { printf "\n${BOLD}${CYAN}══ %s ══${RESET}\n\n" "$1"; }

confirm() {
  local prompt="${1:-Continue?}"
  printf "  ${YELLOW}?${RESET} %s [y/N] " "$prompt"
  read -r response
  [[ "$response" =~ ^[Yy] ]]
}

printf "\n  ${BOLD}${CYAN}Bartlett Workspace Uninstaller${RESET}\n"
printf "  ${DIM}Removing bart installation${RESET}\n\n"

# ── Check for bart Installation ───────────────────────────────────────────────

if [ ! -d "$BART_HOME" ]; then
  error "bart is not installed (${BART_HOME} not found)"
  exit 1
fi

# ── Get Workspace Path from Config ────────────────────────────────────────────

workspace_path=""
if [ -f "$BART_CONFIG" ]; then
  # Read BART_ROOT from config
  if grep -q "^BART_ROOT=" "$BART_CONFIG"; then
    workspace_path=$(grep "^BART_ROOT=" "$BART_CONFIG" | cut -d'=' -f2-)
    info "Found workspace: ${workspace_path}"
  fi
fi

# ── Confirm Uninstallation ────────────────────────────────────────────────────

header "Uninstallation Options"

printf "  ${BOLD}What would you like to remove?${RESET}\n\n"
printf "    ${BOLD}1)${RESET} Remove bart only (keep workspace)\n"
printf "    ${BOLD}2)${RESET} Remove bart + workspace directory\n"
printf "    ${BOLD}3)${RESET} Cancel\n\n"

uninstall_mode=""
while true; do
  printf "  ${YELLOW}?${RESET} Enter choice [1-3] (default: 1): "
  read -r choice

  case "${choice:-1}" in
    1)
      uninstall_mode="bart-only"
      break
      ;;
    2)
      uninstall_mode="full"
      break
      ;;
    3)
      info "Uninstallation cancelled."
      exit 0
      ;;
    *)
      warn "Invalid choice. Please enter 1, 2, or 3."
      ;;
  esac
done

printf "\n"
warn "This will remove:"
printf "  • ${BART_HOME}/bart (CLI tool)\n"
printf "  • ${BART_HOME}/config\n"
printf "  • ~/.bart from your shell PATH\n"

if [[ "$uninstall_mode" == "full" && -n "$workspace_path" && -d "$workspace_path" ]]; then
  printf "  • ${workspace_path} (workspace directory)\n"
fi

printf "\n"

if ! confirm "Are you sure you want to proceed?"; then
  info "Uninstallation cancelled."
  exit 0
fi

# ── Remove bart Installation ──────────────────────────────────────────────────

header "Removing bart"

# Remove bart home directory
if [ -d "$BART_HOME" ]; then
  rm -rf "$BART_HOME"
  success "Removed ${BART_HOME}"
else
  warn "${BART_HOME} not found, skipping"
fi

# ── Remove PATH Entry from Shell Config ───────────────────────────────────────

header "Cleaning Shell Configuration"

# Detect shell config files
shell_configs=()
[ -f "$HOME/.zshrc" ] && shell_configs+=("$HOME/.zshrc")
[ -f "$HOME/.bashrc" ] && shell_configs+=("$HOME/.bashrc")
[ -f "$HOME/.bash_profile" ] && shell_configs+=("$HOME/.bash_profile")

removed_from_shells=0
for shell_config in "${shell_configs[@]}"; do
  if grep -q "\$HOME/\.bart\|~/.bart\|${BART_HOME}" "$shell_config" 2>/dev/null; then
    # Create backup
    cp "$shell_config" "${shell_config}.backup"

    # Remove bart PATH lines (including the comment line)
    # This removes the comment and the export line that were added by install.sh
    sed -i.tmp '/# Bart CLI (added by install.sh)/d; /export PATH=.*\.bart/d' "$shell_config"
    rm -f "${shell_config}.tmp"

    success "Removed ~/.bart from PATH in ${shell_config}"
    info "Backup saved to ${shell_config}.backup"
    removed_from_shells=$((removed_from_shells + 1))
  fi
done

if [ $removed_from_shells -eq 0 ]; then
  warn "~/.bart not found in any shell config files"
fi

# ── Remove Workspace Directory (if requested) ─────────────────────────────────

if [[ "$uninstall_mode" == "full" ]]; then
  header "Removing Workspace"

  if [[ -z "$workspace_path" ]]; then
    warn "Could not determine workspace path from config"
    printf "  ${YELLOW}?${RESET} Enter workspace path to remove: "
    read -r workspace_path
  fi

  if [[ -n "$workspace_path" && -d "$workspace_path" ]]; then
    # Final confirmation for workspace removal
    warn "About to permanently delete: ${workspace_path}"
    if confirm "This cannot be undone. Remove workspace?"; then
      rm -rf "$workspace_path"
      success "Removed workspace directory"
    else
      info "Kept workspace directory: ${workspace_path}"
    fi
  elif [[ -n "$workspace_path" ]]; then
    warn "Workspace directory not found: ${workspace_path}"
  fi
fi

# ── Complete ──────────────────────────────────────────────────────────────────

header "Uninstallation Complete"

success "bart has been removed"

printf "\n"
info "Next steps:"
printf "  1. Reload your shell or restart your terminal\n"

if [[ "$uninstall_mode" == "bart-only" && -n "$workspace_path" && -d "$workspace_path" ]]; then
  printf "  2. Your workspace is still at: ${workspace_path}\n"
  printf "     To remove it manually: ${BOLD}rm -rf ${workspace_path}${RESET}\n"
fi

printf "\n"
