#!/bin/bash

# Create a Python virtual environment
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

# Install Ansible
pip install ansible

# Install required Python packages
pip install -r requirements.txt

# Install Ansible Galaxy roles and collections
ansible-galaxy install -r requirements.yml