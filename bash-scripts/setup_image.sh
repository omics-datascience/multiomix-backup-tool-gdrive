#!/bin/bash

echo "Installing packages..."
bash /bash-scripts/install_packages.sh

echo "Setting up alternatives..."

echo "Create backup folder"
mkdir -p $BACKUP_DIR
ls -ld $BACKUP_DIR