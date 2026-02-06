#!/usr/bin/env bash
set -euo pipefail

# ── Bartlett Workspace Bootstrap ─────────────────────────────────────────────
# Usage: curl -fsSL https://raw.githubusercontent.com/SalesTrak/bartlett-workspace/main/install.sh | sh

REPO="SalesTrak/bartlett-workspace"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
BART_HOME="${HOME}/.bart"

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

printf "\n  ${BOLD}${CYAN}bart Installer${RESET}\n"
printf "  ${DIM}Installing bart CLI globally${RESET}\n\n"

# Check for curl
if ! command -v curl &>/dev/null; then
  error "curl is required but not installed."
  exit 1
fi

# ── Install bart Globally ─────────────────────────────────────────────────────

header "Installing bart"

# Create ~/.bart directory
mkdir -p "$BART_HOME"
success "Created ${BART_HOME}"

# Download bart script
info "Downloading bart CLI from ${REPO}..."
if curl -fsSL "${BASE_URL}/bart" -o "${BART_HOME}/bart"; then
  chmod +x "${BART_HOME}/bart"
  success "Installed bart to ${BART_HOME}/bart"
else
  error "Failed to download bart CLI"
  exit 1
fi

# ── Update Shell PATH ────────────────────────────────────────────────────────

header "Updating Shell PATH"

# Detect shell and add to PATH
shell_config=""
if [[ -n "${ZSH_VERSION:-}" ]] || [[ "${SHELL:-}" == */zsh ]]; then
  shell_config="$HOME/.zshrc"
elif [[ -n "${BASH_VERSION:-}" ]] || [[ "${SHELL:-}" == */bash ]]; then
  if [[ -f "$HOME/.bash_profile" ]]; then
    shell_config="$HOME/.bash_profile"
  else
    shell_config="$HOME/.bashrc"
  fi
else
  warn "Could not detect shell configuration file"
  info "Manually add 'export PATH=\"\$HOME/.bart:\$PATH\"' to your shell config"
fi

# Add ~/.bart to PATH if we detected a shell config
if [[ -n "$shell_config" ]]; then
  # Check if ~/.bart is already in PATH
  if grep -q "\$HOME/\.bart\|~/.bart\|${BART_HOME}" "$shell_config" 2>/dev/null; then
    warn "~/.bart may already be in PATH (found in ${shell_config})"
    info "Skipping PATH modification."
  else
    echo "" >> "$shell_config"
    echo "# Bart CLI (added by install.sh)" >> "$shell_config"
    echo "export PATH=\"\$HOME/.bart:\$PATH\"" >> "$shell_config"
    success "Added ~/.bart to PATH in ${shell_config}"
  fi
fi

# ── Complete ──────────────────────────────────────────────────────────────────

header "Installation Complete"

success "bart is now available globally"

printf "\n"
info "Next steps:"
printf "  1. Reload your shell: ${BOLD}source ${shell_config}${RESET}\n" || true
printf "  2. Initialize your workspace: ${BOLD}bart init${RESET}\n"
printf "\n"
