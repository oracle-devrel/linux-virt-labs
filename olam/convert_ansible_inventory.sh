#!/bin/bash

# Copyright (c) 2024, 2025 Oracle and/or its affiliates.
# This software is made available to you under the terms of the Universal Permissive License (UPL), Version 1.0.
# The Universal Permissive License (UPL), Version 1.0 (see COPYING or https://oss.oracle.com/licenses/upl)
# See LICENSE.TXT for details.

# Check if input file is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

# Set input file
input_file="$1"

# Check if input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: Input file '$input_file' does not exist."
  exit 1
fi

# Extract hosts and create new format
echo "[control]"
grep "^olam-control-" "$input_file" | sed -E "s/ (ansible_user=opc|ansible_private_key_file=[^ ]+|ansible_ssh_common_args='[^']+')//g" | awk '{print $1, $2, $3}' | sort
echo ""

echo "[control:vars]"
echo "node_type=control"
echo "peers=local_execution_group"
echo ""

echo "[execution]"
grep -E "^olam-(execution|hop|remote-execution)-" "$input_file" | sed -E "s/ (ansible_user=opc|ansible_private_key_file=[^ ]+|ansible_ssh_common_args='[^']+')//g" | awk '{print $1, $2, $3}' | sort
echo ""

echo "[local_execution_group]"
grep "^olam-execution-" "$input_file" | sed -E "s/ (ansible_user=opc|ansible_private_key_file=[^ ]+|ansible_ssh_common_args='[^']+')//g" | awk '{print $1, $2, $3}' | sort
echo ""

echo "[local_execution_group:vars]"
echo "node_type=execution"
echo ""

echo "[hop]"
grep "^olam-hop-" "$input_file" | sed -E "s/ (ansible_user=opc|ansible_private_key_file=[^ ]+|ansible_ssh_common_args='[^']+')//g" | awk '{print $1, $2, $3}'
echo ""

echo "[hop:vars]"
echo "peers=control"
echo ""

echo "[remote_execution_group]"
grep "^olam-remote-execution-" "$input_file" | sed -E "s/ (ansible_user=opc|ansible_private_key_file=[^ ]+|ansible_ssh_common_args='[^']+')//g" | awk '{print $1, $2, $3}'
echo ""

echo "[remote_execution_group:vars]"
echo "peers=hop"
echo ""

echo "[db]"
grep "^olam-db" "$input_file" | sed -E "s/ (ansible_user=opc|ansible_private_key_file=[^ ]+|ansible_ssh_common_args='[^']+')//g" | awk '{print $1, $2, $3}'
echo ""

echo "[all:vars]"
echo "ansible_user=opc"
echo "ansible_private_key_file=/home/luna.user/.ssh/id_rsa"
echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"