#!/usr/bin/env bash

USAGE="Usage: ./build.sh <dir_path_public>"

# Validate usage
if [ "$#" -ne 1 ]; then
    echo "User Error: Incorrect number of arguments supplied."
    echo $USAGE
    exit 1
fi

DIR_PATH_PUBLIC=$1

# Check common usage
if [[ "$DIR_PATH_PUBLIC" != *"/docs" ]]; then
    read -r -p "dir choice doesn't end with \"/docs\". Are you sure? [Y/n] " SURE
    if [ "$SURE" == "n" ]; then
        echo "Cancelled."
        exit 0
    fi
fi

python3 src/main.py "https://jkgarber.com/docs/" "$1"
