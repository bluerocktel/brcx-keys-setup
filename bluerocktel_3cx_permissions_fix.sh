#!/bin/bash
# BlueRockTEL < https://bluerocktel.com >

ssh_dir="/var/lib/3cxpbx/.ssh"
authorized_keys_file="${ssh_dir}/authorized_keys"
private_key_file="${ssh_dir}/id_rsa"
public_key_file="${ssh_dir}/id_rsa.pub"

chmod 700 "${ssh_dir}"
chmod 600 "${authorized_keys_file}"
chmod 600 "${private_key_file}"
chmod 644 "${public_key_file}"
