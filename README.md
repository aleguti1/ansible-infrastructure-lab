# Ansible Infrastructure Lab

This is a self-hosted infrastructure lab created with the intention of learning and demonstrating configuration management and automation using Ansible.

## Lab Environment

This lab uses Oracle VirtualBox for virtualization.

### List of Virtual Machines

| VM | OS | Role | Internal IP |
| --- | --- | --- | --- |
| ansible01 | Ubuntu Server | Ansible control node | 192.168.2.1 |
| linux01 | Ubuntu Server | Managed Linux node | 192.168.2.11 |

## Current Capabilities

- SSH key-based authentication between the Ansible control node and managed nodes
- Ansible inventory with a list of Linux hosts

## Planned Capabilities

- Automate Linux configuration using Ansible playbooks
- Expand this to Windows Server and Active Directory
