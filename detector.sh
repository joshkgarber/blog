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

# Function to generate SHA256 hashes for all non-directory files
generate_hashes() {
    find "$TARGET_DIR" -name '*\.md' -type f -print0 | while IFS= read -r -d $'\0' file; do
        # Ignore the baseline file itself if it happens to be inside the target directory
        if [[ "$file" != "$BASELINE_FILE" ]]; then
            sha256sum "$file"
        fi
    done | sort -k 2 | awk '{print $2 "\t" $1}' > "$1" # Sort by filename (field 2) for reliable comparison
}

# Function to display the usage instructions
show_usage() {
    echo "Usage: $0 <init|check|reset> [basepath] [dir_path_public]"
    echo ""
    echo "  init    : Creates the initial baseline of hashes. Must be run first."
    echo "  check   : Compares current files against the baseline to detect changes, and build the site if changes are found. basepath and  dir_path_public must be provided."
    echo "  reset   : Overwrites the baseline with the current state, ignoring all changes."
    echo ""
    echo "Monitoring directory: $TARGET_DIR"
    echo "Baseline file: $BASELINE_FILE"
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
BASEPATH=$2
DIR_PATH_PUBLIC="$3"

case "$COMMAND" in
    init)
        echo "--> Initializing baseline for $TARGET_DIR..."
        if [ -f "$BASELINE_FILE" ]; then
            echo "Baseline file already exists. Use 'reset' to overwrite or 'check' to compare."
            exit 1
        fi
        
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

    check)
        if [ ! -f "$BASELINE_FILE" ]; then
            echo "Error: Baseline file not found. Please run '$0 init' first."
            exit 1
        fi

        if [ -z "$2" ]; then
            show_usage
            exit 1
        fi

        # Log run
        echo -e "$(date +%F_%T)\tDETECTING CHANGES"

        # Generate current hashes and store them temporarily
        generate_hashes "$TEMP_FILE"

        CHANGES_FOUND=false

        DELETED_LINES=$(comm -23 <(sort "$BASELINE_FILE" | awk '{print $1}') <(sort "$TEMP_FILE" | awk '{print $1}'))

        if [ -n "$DELETED_LINES" ]; then
            CHANGES_FOUND=true
            echo "$DELETED_LINES" | awk '{print strftime("%F_%T", systime()) "\tDEL\t" $1}'
        fi

        ADDED_LINES=$(comm -13 <(sort "$BASELINE_FILE" | awk '{print $1}') <(sort "$TEMP_FILE" | awk '{print $1}'))

        if [ -n "$ADDED_LINES" ]; then
            CHANGES_FOUND=true
            echo "$ADDED_LINES" | awk '{print strftime("%F_%T", systime()) "\tADD\t" $1}'
        fi
        
        MODIFIED_LINES=$(comm -3 "$BASELINE_FILE" "$TEMP_FILE" | grep -Ff <(awk '{print $1}' "$BASELINE_FILE") | grep -Ff <(awk '{print $1}' "$TEMP_FILE") | awk '{print $1}' | sort | uniq)

        if [ -n "$MODIFIED_LINES" ]; then
            CHANGES_FOUND=true
            echo "$MODIFIED_LINES" | awk '{print strftime("%F_%T", systime()) "\tMOD\t" $1}'
        fi

        if [ "$CHANGES_FOUND" = true ]; then
            if [[ "$DIR_PATH_PUBLIC" != *"/docs" ]]; then
                read -r -p "dir choice doesn't end with \"/docs\". Are you sure? [Y/n] " SURE
                if [ "$SURE" == "n" ]; then
                    echo "Cancelled."
                    if [ -f "$TEMP_FILE" ]; then
                        rm "$TEMP_FILE"
                    fi
                    exit 0
                fi
            fi
            echo -e "$(date +%F_%T)\tSTARTING BUILD"
            python3 src/main.py "$2" "$3"
            echo -e "$(date +%F_%T)\tBUILD COMPLETED"
            mv "$TEMP_FILE" "$BASELINE_FILE"
            echo -e "$(date +%F_%T)\tBASELINE HASHES UPDATED"
            echo -e "$(date +%F_%T)\tEXITING"
        else
            echo -e "$(date +%F_%T)\tNO CHANGES FOUND"
            echo -e "$(date +%F_%T)\tEXITING"
        fi
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

