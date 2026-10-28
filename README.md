# Ansible Infrastructure Lab

This is a self-hosted infrastructure lab created with the intention of learning and demonstrating configuration management and automation using Ansible.

## Lab Environment

This lab uses Oracle VirtualBox for virtualization. Each VM is configured with a NAT adapter (for internet access) and an internal network adapter. This project is maintained in a local Git repository on the control node.

### List of Virtual Machines

| VM | OS | Role | Internal IP |
| --- | --- | --- | --- |
| ansible01 | Ubuntu Server | Ansible control node | 192.168.2.1 |
| linux01 | Ubuntu Server | Managed Linux node/Nginx Web Server | 192.168.2.11 |

## Current Capabilities

- SSH key-based authentication between the Ansible control node and managed nodes
- Ansible inventory with a list of Linux hosts
- Ansible playbooks to automate Linux configuration (in progress)
- Intranet web server using Nginx (in progress)

## Planned Capabilities

- Expand this to Windows Server and Active Directory
- Implement infrastructure monitoring
