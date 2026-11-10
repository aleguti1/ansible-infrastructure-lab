# Ansible Infrastructure Lab

This is a self-hosted infrastructure lab created with the intention of learning and demonstrating configuration management and automation using Ansible.

## Lab Environment

This lab uses Oracle VirtualBox for virtualization. Each VM is configured with a NAT adapter (for internet access) and an internal network adapter. This project is maintained in a local Git repository on the control node.

### List of Virtual Machines

| VM | OS | Role | Internal IP |
| --- | --- | --- | --- |
| ansible01 | Ubuntu Server 26.04 LTS | Ansible control node | 192.168.2.1 |
| linux01 | Ubuntu Server 26.04 LTS | Managed Linux node/Nginx Web Server | 192.168.2.11 |
| dc01 | Windows Server 2025 Standard Evaluation | Active Directory Domain Controller | 192.168.2.10 |

## Current Capabilities

- Reproducible Ansible control node setup using a bootstrap script
- Centralized, idempotent infrastructure automation through `site.yml`
- Linux server configuration, including package management, services, and an Nginx intranet
- Windows Server management over WinRM
- Automated Active Directory deployment (`halcyon.internal`) including Domain Controller promotion
- Encrypted credential management using Ansible Vault
- Internal DNS configuration for intranet access
- AD OU management

## Planned Capabilities

- AD Security Group management
- Configure WinRM over HTTPS
- Infrastructure monitoring
- More streamlined bootstrap process/fewer manual steps
