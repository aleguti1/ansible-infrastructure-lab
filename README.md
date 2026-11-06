# Ansible Infrastructure Lab

This is a self-hosted infrastructure lab created with the intention of learning and demonstrating configuration management and automation using Ansible.

## Lab Environment

This lab uses Oracle VirtualBox for virtualization. Each VM is configured with a NAT adapter (for internet access) and an internal network adapter. This project is maintained in a local Git repository on the control node.

### List of Virtual Machines

| VM | OS | Role | Internal IP |
| --- | --- | --- | --- |
| ansible01 | Ubuntu Server 26.04 LTS | Ansible control node | 192.168.2.1 |
| linux01 | Ubuntu Server 26.04 LTS | Managed Linux node/Nginx Web Server | 192.168.2.11 |
| dc01 | Windows Server 2025 Standard Evaluation | Active Directory Domain Controller (planned) | 192.168.2.10 |

## Current Capabilities

- Reproducible Ansible control node setup using a bootstrap script
- SSH key-based authentication between the Ansible control node and managed Linux nodes
- Ansible inventory for Linux and Windows hosts
- Ansible playbooks for Linux package installation, service management, and Nginx configuration
- Intranet web server using Nginx
- WinRM connectivity to Windows Server using NTLM authentication over HTTP within the lab network
- Windows system information gathering via Ansible

## Planned Capabilities

- Promote dc01 to a domain controller and create the Active Directory domain
- Configure DNS
- Configure WinRM over HTTPS
- Add a Windows client and join it to the Active Directory domain
- Implement infrastructure monitoring
