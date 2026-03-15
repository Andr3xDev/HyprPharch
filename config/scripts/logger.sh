#!/bin/bash

# Import this script in any of your other scripts to enable logging functionality.
# It will create a log file for each script that sources it, and log messages with 
# timestamps and levels.

LOG_DIR="${HOME}/.config/logs"
mkdir -p "$LOG_DIR"

# Use this function to log messages with different levels (INFO, ERROR, etc.)
# Example usage:
# log "INFO" "This is an informational message."
log() {
    local level="$1"
    local message="$2"
    local script_name
    script_name="$(realpath "${BASH_SOURCE[1]}" | sed "s|${HOME}/.config/||" | sed 's|/|-|g' | sed 's|\.sh$||')"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

    echo "[$timestamp] [$level] $message" >> "${LOG_DIR}/${script_name}.log"
}

# This function will be called whenever an error occurs in any script that sources
# this logger.sh file. It will log the error message along with the line number 
# where the error occurred and the exit code of the command that failed.
_log_error_trap() {
    local exit_code=$?
    local line="$1"
    log ERROR "Fallo inesperado en línea $line (exit code: $exit_code)"
}

trap '_log_error_trap $LINENO' ERR