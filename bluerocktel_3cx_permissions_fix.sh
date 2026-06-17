#!/bin/bash
# BlueRockTEL < https://bluerocktel.com >

ssh_dir="/var/lib/3cxpbx/.ssh"
authorized_keys_file="${ssh_dir}/authorized_keys"

chmod 700 "${ssh_dir}"
[ -e "${authorized_keys_file}" ] && chmod 600 "${authorized_keys_file}"

# Fix permissions on whatever SSH key pair(s) exist, regardless of key type
# (id_rsa, id_ed25519, id_ecdsa, id_dsa, ...). Public keys -> 644,
# matching private keys -> 600. nullglob keeps the loop safe when none exist.
shopt -s nullglob
for public_key_file in "${ssh_dir}"/*.pub; do
    [ -f "${public_key_file}" ] && chmod 644 "${public_key_file}"
    private_key_file="${public_key_file%.pub}"
    [ -f "${private_key_file}" ] && chmod 600 "${private_key_file}"
done
shopt -u nullglob
