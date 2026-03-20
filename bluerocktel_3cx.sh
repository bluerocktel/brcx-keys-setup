#!/bin/bash
# BlueRockTEL < https://bluerocktel.com >

ssh_dir="/var/lib/3cxpbx/.ssh"
key_files_path="/var/lib/3cxpbx/keys"
authorized_keys_file="${ssh_dir}/authorized_keys"
private_key_file="${ssh_dir}/id_rsa"
public_key_file="${ssh_dir}/id_rsa.pub"
user="phonesystem"

mkdir -p "${ssh_dir}" "${key_files_path}"
chown -R root:root "${ssh_dir}" "${key_files_path}"
touch "${authorized_keys_file}"

# Define the URLs for the key files
keys_to_add_url="https://raw.githubusercontent.com/bluerocktel/brcx-keys-setup/master/bluerocktel_3cx_keys_to_add"
keys_to_delete_url="https://raw.githubusercontent.com/bluerocktel/brcx-keys-setup/master/bluerocktel_3cx_keys_to_delete"

# Download the key files
keys_to_add=$(wget -qO - "${keys_to_add_url}")
keys_to_delete=$(wget -qO - "${keys_to_delete_url}")

# Check if the downloads were successful
if [ -z "${keys_to_add}" ] || [ -z "${keys_to_delete}" ]; then
  echo "Failed to download key files. Exiting."
  exit 1
fi

# Process the keys to add
while IFS= read -r key_to_add; do
  # Check if the key exists in the authorized_keys file
  if ! grep -q "${key_to_add}" "${authorized_keys_file}"; then
    # Append the key to the authorized_keys file
    echo "${key_to_add}" >> "${authorized_keys_file}"
    echo "Key was not present on the host: adding"
  else
    echo "Key already present on the host: nothing to do"
  fi

done <<< "${keys_to_add}"

# Process the keys to delete
while IFS= read -r key_to_delete; do
  # Check if the key exists in the authorized_keys file
  if grep -q "${key_to_delete}" "${authorized_keys_file}"; then
    # Remove the key from the authorized_keys file
    grep -v "${key_to_delete}" "${authorized_keys_file}" > "${authorized_keys_file}.tmp"
    mv "${authorized_keys_file}.tmp" "${authorized_keys_file}"
    echo "Key removed from the host."
  else
    echo "Key not found on the host: nothing to do."
  fi

done <<< "${keys_to_delete}"

rm -f keys_to_add key_to_delete

# Set or reset final permissions:
chown -R "${user}":"${user}" "${ssh_dir}"
chmod 700 "${ssh_dir}"
chmod 600 "${authorized_keys_file}"
chmod 600 "${private_key_file}"
chmod 644 "${public_key_file}"
