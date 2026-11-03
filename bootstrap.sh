#!/bin/bash
set -e
cd "$(dirname "$0")"

# Install package needed to create a venv
sudo apt-get update
sudo apt-get install -y python3-venv

# Create the virtual environment
python3 -m venv .venv

# Install required Python packages
.venv/bin/python -m pip install -r requirements.txt

# Activate the venv via:
# source .venv/bin/activate
# inside ansible-lab

# Install required Ansible collections
.venv/bin/ansible-galaxy collection install -r collections/requirements.yml
