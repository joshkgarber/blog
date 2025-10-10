#!/usr/bin/env bash

# ===============================================
# Configuration
# ===============================================

# Directory to monitor (Use absolute path for stability)
TARGET_DIR="./content"

# File to store the baseline SHA256 hashes
BASELINE_FILE="./.baseline_hashes"

# Temporary file used for the current scan's hashes
TEMP_FILE="./.current_hashes_temp"

# ===============================================
# Helper Functions
# ===============================================

# Function to display the usage instructions
show_usage() {
    echo "Usage: $0 [init|check|reset]"
    echo ""
    echo "  init    : Creates the initial baseline of hashes. Must be run first."
    echo "  check   : Compares current files against the baseline to report changes."
    echo "  reset   : Overwrites the baseline with the current state, ignoring all changes."
    echo ""
    echo "Monitoring directory: $TARGET_DIR"
    echo "Baseline file: $BASELINE_FILE"
}

# Function to generate SHA256 hashes for all non-directory files
generate_hashes() {
    # Find all regular files in the target directory (excluding the baseline file itself)
    # Use -type f to ensure we only hash files, not directories.
    # We pipe the paths to sha256sum to generate the hash, and then we format the output
    # to be sortable (hash and then filepath).
    find "$TARGET_DIR" -type f -print0 | while IFS= read -r -d $'\0' file; do
        # Ignore the baseline file itself if it happens to be inside the target directory
        if [[ "$file" != "$BASELINE_FILE" ]]; then
            sha256sum "$file"
        fi
    done | sort -k 2 > "$1" # Sort by filename (field 2) for reliable comparison
}

# ===============================================
# Main Execution Logic
# ===============================================

# Check for a command argument
if [ -z "$1" ]; then
    show_usage
    exit 1
fi

COMMAND="$1"

case "$COMMAND" in
    init)
        echo "--> Initializing baseline for $TARGET_DIR..."
        if [ -f "$BASELINE_FILE" ]; then
            echo "Baseline file already exists. Use 'reset' to overwrite or 'check' to compare."
            exit 1
        fi
        
        # Create the target directory if it doesn't exist
        mkdir -p "$TARGET_DIR"

        generate_hashes "$BASELINE_FILE"
        echo "Baseline created successfully in $BASELINE_FILE."
        echo "Found $(wc -l < "$BASELINE_FILE") files."
        ;;

    reset)
        echo "--> Resetting baseline for $TARGET_DIR..."
        mkdir -p "$TARGET_DIR"
        generate_hashes "$BASELINE_FILE"
        echo "Baseline reset successfully. Current state saved."
        ;;

    *)
        show_usage
        exit 1
        ;;
esac

# Clean up temporary file on exit (if it exists)
if [ -f "$TEMP_FILE" ]; then
    rm "$TEMP_FILE"
fi

exit 0

