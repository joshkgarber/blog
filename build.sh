#!/usr/bin/env bash

USAGE="Usage: ./build.sh <basepath> <dir_path_public>"

# Validate usage
if [ "$#" -ne 2 ]; then
    echo "User Error: Incorrect number of arguments supplied."
    echo $USAGE
    exit 1
fi

BASEPATH=$1
DIR_PATH_PUBLIC=$2

# Check common usage
if [[ "$DIR_PATH_PUBLIC" != *"/docs" ]]; then
    read -r -p "dir choice doesn't end with \"/docs\". Are you sure? [Y/n] " SURE
    if [ "$SURE" == "n" ]; then
        echo "Cancelled."
        exit 0
    fi
fi

python3 src/main.py "$1" "$2"
