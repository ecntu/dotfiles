#!/usr/bin/env bash

# Raycast Script Command Template
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title SSH to Rsync
# @raycast.mode compact
# @raycast.packageName Raycast Scripts
# @raycast.argument1 { "type": "text", "placeholder": "SSH string" }
#
# Optional parameters:
# @raycast.icon 🤖
# @raycast.currentDirectoryPath ~
# @raycast.needsConfirmation false
#
# Documentation:
# @raycast.description Converts an SSH string "ssh usr@host -p 123" to my most used rsync cmd
# @raycast.author E. Cantu

# Get the SSH string from the first argument
ssh_string="$1"

# Split the SSH string into components
read -r _ host _ port <<< "$ssh_string"

# Print the rsync command
echo "rsync -avz --exclude-from=.gitignore --exclude=\".git/*\" -e 'ssh -p $port' ./ $host:~/" | pbcopy
