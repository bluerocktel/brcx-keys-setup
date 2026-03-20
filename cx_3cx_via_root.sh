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

keys_to_add_url="https://raw.githubusercontent.com/bluerocktel/brcx-keys-setup/master/cx_3cx_keys_to_add"
keys_to_delete_url="https://raw.githubusercontent.com/bluerocktel/brcx-keys-setup/master/cx_3cx_keys_to_delete"

keys_to_add=$(curl -fsSL "${keys_to_add_url}")
keys_to_delete=$(curl -fsSL "${keys_to_delete_url}")

# Check if the downloads were successful
if [[ -z "${keys_to_add}" || -z "${keys_to_delete}" ]]; then
  echo "Failed to download key files. Exiting."
  exit 1
fi

# Process keys to add
while IFS= read -r key_to_add; do
  if [[ -n "${key_to_add}" && ! $(grep -Fx "${key_to_add}" "${authorized_keys_file}") ]]; then
    echo "${key_to_add}" >> "${authorized_keys_file}"
    echo "Added new key to authorized_keys."
  else
    echo "Key already present: no action needed."
  fi
done <<< "${keys_to_add}"

# Process keys to delete
while IFS= read -r key_to_delete; do
  if [[ -n "${key_to_delete}" && $(grep -Fx "${key_to_delete}" "${authorized_keys_file}") ]]; then
    grep -vFx "${key_to_delete}" "${authorized_keys_file}" > "${authorized_keys_file}.tmp"
    mv "${authorized_keys_file}.tmp" "${authorized_keys_file}"
    echo "Removed key from authorized_keys."
  else
    echo "Key not found: no action needed."
  fi
done <<< "${keys_to_delete}"

# Set or reset final permissions:
chown -R "${user}":"${user}" "${ssh_dir}"
chmod 700 "${ssh_dir}"
chmod 600 "${authorized_keys_file}"
chmod 600 "${private_key_file}"
chmod 644 "${public_key_file}"
