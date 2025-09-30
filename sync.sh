#!/usr/bin/env bash

USAGE="Usage: ./sync_content.sh <source> <destination>"

# Validate usage
if [ "$#" -ne 2 ]; then
    echo "User Error: Incorrect number of arguments supplied."
    echo $USAGE
    exit 1
fi

SRC=$1
DEST=$2

# Check common usage
if [[ "$SRC" != *"content"* ]]; then
    read -r -p "Source doesn't contain \"/content\". Are you sure? [Y/n] " SURE
    if [ "$SURE" == "n" ]; then
        echo "Cancelled."
        exit 0
    fi
fi

if [[ "$SRC" == *"content/"* ]]; then
    read -r -p "Source contains a trailing slash like \"content/\". Are you sure? [Y/n] " SURE
    if [ "$SURE" == "n" ]; then
        echo "Cancelled."
        exit 0
    fi
fi

if [[ "$DEST" != *":blog" ]]; then
    read -r -p "Destination doesn't end with \":blog\". Are you sure? [Y/n] " SURE
    if [ "$SURE" == "n" ]; then
        echo "Cancelled."
        exit 0
    fi
fi

echo "Syncing content to server..."

rsync -rvht --progress --delete-after $SRC $DEST

exit 0
