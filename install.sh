#!/usr/bin/env bash
set -euo pipefail

# ── Bartlett Workspace Bootstrap ─────────────────────────────────────────────
# Usage: curl -fsSL https://raw.githubusercontent.com/SalesTrak/bartlett-workspace/main/install.sh | sh

REPO="SalesTrak/bartlett-workspace"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
INSTALL_DIR="${HOME}/develop/bartlett-workspace"

# Colors (if terminal supports them)
if [ -t 1 ]; then
  BOLD='\033[1m'
  CYAN='\033[0;36m'
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  DIM='\033[2m'
  RESET='\033[0m'
else
  BOLD='' CYAN='' GREEN='' RED='' DIM='' RESET=''
fi

info()    { printf "  ${CYAN}>${RESET} %s\n" "$1"; }
success() { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
error()   { printf "  ${RED}✗${RESET} %s\n" "$1"; }

printf "\n  ${BOLD}${CYAN}Bartlett Workspace Installer${RESET}\n"
printf "  ${DIM}Setting up your development environment${RESET}\n\n"

# Check for curl
if ! command -v curl &>/dev/null; then
  error "curl is required but not installed."
  exit 1
fi

# Create workspace directory
if [ -d "$INSTALL_DIR" ]; then
  error "Directory already exists: ${INSTALL_DIR}"
  info "Remove it first or run ./bart init from inside it."
  exit 1
fi

info "Creating ${INSTALL_DIR}"
mkdir -p "$INSTALL_DIR"

# Download workspace files
info "Downloading bart CLI..."
curl -fsSL "${BASE_URL}/bart" -o "${INSTALL_DIR}/bart"
chmod +x "${INSTALL_DIR}/bart"
success "bart CLI downloaded"

info "Downloading CLAUDE.md..."
curl -fsSL "${BASE_URL}/CLAUDE.md" -o "${INSTALL_DIR}/CLAUDE.md"
success "CLAUDE.md downloaded"

success "Workspace created at ${INSTALL_DIR}"
printf "\n"

# Run init
info "Starting workspace setup...\n"
cd "$INSTALL_DIR"
exec ./bart init
