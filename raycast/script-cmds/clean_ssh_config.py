#!/usr/bin/env python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clean SSH Config
# @raycast.mode fullOutput
# @raycast.packageName Raycast Scripts
#
# Optional parameters:
# @raycast.icon 🤖
# @raycast.currentDirectoryPath ~
# @raycast.needsConfirmation false
#
# Documentation:
# @raycast.description Cleans up SSH config files by removing entries with hardcoded IPs or blacklisted domains.
# @raycast.author E. Cantu

import os
import re
import shutil

BLACKLIST = ["jarvislabs.ai"]


def find_ssh_files():
    """Locates the default SSH config and known_hosts files."""
    home_dir = os.path.expanduser("~")
    ssh_dir = os.path.join(home_dir, ".ssh")
    config_path = os.path.join(ssh_dir, "config")
    known_hosts_path = os.path.join(ssh_dir, "known_hosts")
    return config_path, known_hosts_path


def is_ipv4(address):
    """Checks if a string is a valid IPv4 address."""
    # Regex to match a standard IPv4 address
    ipv4_pattern = re.compile(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")
    if not ipv4_pattern.match(address):
        return False
    # Check octet values
    parts = address.split(".")
    for part in parts:
        if not (0 <= int(part) <= 255):
            return False
    return True


def is_blacklisted(host_alias):
    """Checks if a host alias or hostname contains a blacklisted domain."""
    host_alias = host_alias.strip().lower()
    return host_alias in BLACKLIST or any(h in host_alias for h in BLACKLIST)


def clean_ssh_config(config_path):
    """
    Reads the SSH config file, identifies entries with hardcoded IPs or
    blacklisted domains, and returns the lines to keep.
    """
    if not os.path.exists(config_path):
        print(f"SSH config file not found at: {config_path}")
        return []

    print(f"\n--- Processing {config_path} ---")
    with open(config_path, "r") as f:
        lines = f.readlines()

    cleaned_lines = []
    current_host_block = []
    should_delete_block = False
    deleted_hosts = []

    for line in lines:
        stripped_line = line.strip()

        if stripped_line.lower().startswith("host "):
            # If we've finished a block, decide whether to keep it
            if current_host_block:
                if not should_delete_block:
                    cleaned_lines.extend(current_host_block)
                else:
                    # Extract the host alias from the first line of the deleted block
                    host_alias_to_log = current_host_block[0].strip()[5:].strip()
                    deleted_hosts.append(host_alias_to_log)
                    print(f"  [!] Deleting Host '{host_alias_to_log}' block.")

            # Start a new host block
            current_host_block = [line]
            should_delete_block = False  # Reset flag for the new block

            host_alias = stripped_line[5:].strip()
            if is_ipv4(host_alias):
                should_delete_block = True
            elif is_blacklisted(host_alias):  # Check for blacklisted alias
                should_delete_block = True
                print(
                    f"  [!] Marking Host '{host_alias}' for deletion (Blacklisted alias)."
                )

        elif stripped_line.lower().startswith("hostname "):
            current_host_block.append(line)
            hostname_value = stripped_line[9:].strip()
            if is_ipv4(hostname_value):
                should_delete_block = True
            elif is_blacklisted(hostname_value):  # Check for blacklisted hostname
                should_delete_block = True
                # Try to get the Host alias from the current_host_block if available
                host_line = next(
                    (
                        l
                        for l in current_host_block
                        if l.strip().lower().startswith("host ")
                    ),
                    None,
                )
                if host_line:
                    host_alias = host_line.strip()[5:].strip()
                    print(
                        f"  [!] Marking Host '{host_alias}' for deletion (Blacklisted HostName: {hostname_value})."
                    )
                else:
                    print(
                        f"  [!] Marking an unknown host block for deletion (Blacklisted HostName: {hostname_value})."
                    )
        else:
            # Append all other lines to the current block
            current_host_block.append(line)

    # After the loop, process the very last block
    if current_host_block:
        if not should_delete_block:
            cleaned_lines.extend(current_host_block)
        else:
            host_alias_to_log = current_host_block[0].strip()[5:].strip()
            deleted_hosts.append(host_alias_to_log)
            print(f"  [!] Deleting Host '{host_alias_to_log}' block.")

    if deleted_hosts:
        print(f"\nFound and deleted in config: {', '.join(deleted_hosts)}")
    else:
        print("No hardcoded IP or blacklisted entries found in config.")

    return cleaned_lines


def clean_known_hosts(known_hosts_path):
    """
    Reads the known_hosts file, identifies entries starting with hardcoded IPs,
    and returns the lines to keep.
    """
    if not os.path.exists(known_hosts_path):
        print(f"Known_hosts file not found at: {known_hosts_path}")
        return []

    print(f"\n--- Processing {known_hosts_path} ---")
    with open(known_hosts_path, "r") as f:
        lines = f.readlines()

    cleaned_lines = []
    deleted_entries = []

    for line in lines:
        # Known_hosts entries start with hostname or IP
        first_part = (
            line.split(" ")[0].split(",")[0].strip()
        )  # Handle comma-separated hosts
        if is_ipv4(first_part):
            deleted_entries.append(first_part)
            print(
                f"  [!] Marking known_hosts entry '{first_part}' for deletion (IP address)."
            )
        elif is_blacklisted(first_part):  # Check for blacklisted known_hosts entry
            deleted_entries.append(first_part)
            print(
                f"  [!] Marking known_hosts entry '{first_part}' for deletion (Blacklisted domain)."
            )
        else:
            cleaned_lines.append(line)

    if deleted_entries:
        print(
            f"\nFound and marked for deletion in known_hosts: {', '.join(deleted_entries)}"
        )
    else:
        print("No hardcoded IP or blacklisted entries found in known_hosts.")

    return cleaned_lines


def main():
    config_path, known_hosts_path = find_ssh_files()

    print("This script will identify and remove entries with hardcoded IPv4 addresses")
    print("and blacklisted domains from your SSH config and known_hosts files.")
    print("Backup files (.bak) will be created before any changes are made.")

    # Get content to be kept
    config_to_keep = clean_ssh_config(config_path)
    known_hosts_to_keep = clean_known_hosts(known_hosts_path)

    # Check if any changes are planned
    config_changed = len(config_to_keep) != (
        len(open(config_path, "r").readlines()) if os.path.exists(config_path) else 0
    )
    known_hosts_changed = len(known_hosts_to_keep) != (
        len(open(known_hosts_path, "r").readlines())
        if os.path.exists(known_hosts_path)
        else 0
    )

    if not config_changed and not known_hosts_changed:
        print(
            "\nNo hardcoded IP or blacklisted entries found in either file. No changes needed."
        )
        return

    # confirmation = input("\nDo you want to proceed with deleting these entries? (yes/no): ").lower()
    confirmation = (
        "yes"  # Auto-confirm for Raycast usage; change to input() for manual use
    )

    if confirmation == "yes":
        # Process SSH config
        if config_changed:
            try:
                shutil.copyfile(config_path, config_path + ".bak")
                with open(config_path, "w") as f:
                    f.writelines(config_to_keep)
                print(
                    f"Successfully updated {config_path}. Original backed up to {config_path}.bak"
                )
            except Exception as e:
                print(f"Error updating {config_path}: {e}")
        else:
            print(f"No changes to {config_path}.")

        # Process known_hosts
        if known_hosts_changed:
            try:
                shutil.copyfile(known_hosts_path, known_hosts_path + ".bak")
                with open(known_hosts_path, "w") as f:
                    f.writelines(known_hosts_to_keep)
                print(
                    f"Successfully updated {known_hosts_path}. Original backed up to {known_hosts_path}.bak"
                )
            except Exception as e:
                print(f"Error updating {known_hosts_path}: {e}")
        else:
            print(f"No changes to {known_hosts_path}.")
    else:
        print("Operation cancelled. No changes were made.")


if __name__ == "__main__":
    main()
