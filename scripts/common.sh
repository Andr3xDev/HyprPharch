#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Print functions
print_message() { echo -e "${BLUE}==>${NC} ${1}"; }
print_success() { echo -e "${GREEN}✓${NC} ${1}"; }
print_error() { echo -e "${RED}✗${NC} ${1}"; }
print_warning() { echo -e "${YELLOW}!${NC} ${1}"; }

print_banner() {
    clear
    echo -e "${MAGENTA}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}  ${CYAN}${1}${NC}$(printf '%*s' $((43 - ${#1})) '')${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════╝${NC}"
    echo
}

# Utility functions
command_exists() { command -v "$1" &> /dev/null; }

# Ask function
ask() {
    read -p "$1 (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}
