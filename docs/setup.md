## Introduction
**DISCLAIMER:** This document is a work in progress. Not every step has been tested thoroughly to ensure reproducibility. 

This guide will explain how you can set up and host this project on your personal computer.
### Overview of Virtual Machines

| VM Name   | Role                                |
| --------- | ----------------------------------- |
| ansible01 | Ansible Control Node                |
| linux01   | Nginx Intranet Web Server           |
| linux02   | Monitoring Server                   |
| dc01      | Active Directory Domain Controller  |

### Basic System Requirements
This guide requires a computer with an x86-64 (AMD or Intel) processor running Windows, Linux, or macOS. Since it uses x86-64 operating system images, it is not intended for ARM-based processors, such as Apple Silicon Macs.

Your computer should have sufficient CPU cores, RAM, and storage space for each VM to run simultaneously. Additionally, an internet connection is required to clone the GitHub repository and install necessary packages.
### Installing VirtualBox

This project uses several virtual machines and could potentially work with different hypervisors, though this guide focuses exclusively on Oracle VirtualBox, which you may download [here.](https://www.virtualbox.org/wiki/Downloads) This lab was tested using version `7.2.20r175154` on Linux. Different versions of VirtualBox may have different interfaces but should nevertheless include all the necessary functionality.
## Setup
After VirtualBox is successfully installed, you will need to create and configure each VM.
### Downloading ISO Files
Download [Ubuntu Server 26.04](https://ubuntu.com/download/server) from the official Ubuntu website. This lab was tested using **Ubuntu Server 26.04 LTS (64-bit)** which is also available [here](https://releases.ubuntu.com/26.04/).

Download [Windows Server 2025](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2025) from the official Microsoft Evaluation Center. This lab was tested using **Windows Server 2025 Standard Evaluation (Desktop Experience)**, installed from the 64-bit ISO.
### Configuring The Ansible Control Node VM
#### Creating the VM
In VirtualBox, create a new virtual machine.

Under "Virtual machine name and operating system:"
- Give the VM a name, such as `ansible01`
- For "ISO Image:" 
	- Select the Ubuntu Server 26.04 ISO file you downloaded.
	- Leave "proceed with Unattended Installation" checked.

Under "Set up unattended guest OS installation:"
- Enter `localadmin` as the username and choose a password. You will need to remember these credentials later to log into the machine.

Under "Specify virtual hardware:"
- For base memory: use 2 GB.
- For CPUs: use 1 core.
- You may leave "Use EFI" unchecked.

Under "Specify virtual disk:"
- For disk size, allocate 25 GB.

Then, click "Finish" to create the VM.

#### Network Adapters
After the Ansible control node VM has been created, you will need to configure its network adapters on VirtualBox. Right click the VM from the VirtualBox GUI, select Settings, and go to the "Network" tab. There, you should see a list of adapters.

Adapter 1 will allow the VM to access the internet. Use the following settings:
- Enable Network Adapter: Checked
- Attached to: NAT
- Virtual Cable Connected: Checked

Optionally, if you wish to configure this VM directly from your local computer using SSH, click "Port Forwarding" under Adapter 1 and fill the fields as follows:
- Name: `SSH-ansible01`
- Protocol: `TCP`
- Host IP: `127.0.0.1`
- Host Port: `2222` (or any other available port greater than 1023)
- Guest Port: `22`
Then, you may run `ssh -p 2222 localadmin@127.0.0.1` to set up an SSH connection once the VM is running.

Adapter 2 will allow the VMs to communicate with each other through a virtual switch. Use the following settings:
- Enabled Network Adapter: Checked
- Attached to: Internal Network
- Name: `ANSIBLENET` (or any name of your choice, but it must be the same across all VMs)
- Promiscuous Mode: Deny
- Virtual Cable Connected: Checked

#### Accessing the Shell
To access the shell, you will first need to run the VM from VirtualBox. If this is the first time it's running, you may need to wait a few minutes for the OS to install.

Once the OS has booted, you may log into `localadmin` on the terminal. Alternatively, if you set up port forwarding, you may run `ssh -p 2222 localadmin@127.0.0.1` on your local computer's terminal to access the VM via SSH.
#### Bootstrapping 

Before cloning the repository, you will need to ensure Git is installed.
```bash
sudo apt update
sudo apt install -y git
```

Then, you may clone the repository.
```bash
git clone https://github.com/aleguti1/ansible-infrastructure-lab.git
```

Change to the repository root.
```bash
cd ansible-infrastructure-lab
```

Unless otherwise specified, every command in this guide will be run inside the repository root. 

Run the bootstrap script to create the virtual environment and install necessary packages.
```bash
./bootstrap.sh
```

You should then be able to activate the virtual environment. **You will need to do this every time you wish to run Ansible commands,** as they should use the virtual environment and may require packages installed in it.
```bash
source .venv/bin/activate
```

Generate an SSH key.
```bash
ssh-keygen -t ed25519
```
Press Enter to accept the default file location. You may optionally configure a passphrase to protect the private key, which is recommended.

Finally, run the network script to ensure this VM has an IP on the internal network, allowing it to communicate with the other VMs in the future.
```bash
./scripts/configure-network.sh auto
```
When prompted, enter the `sudo` password.

### Configuring the Managed Linux Nodes
The configuration process for the managed Linux nodes is very similar, though with a few minor differences. The following sub-sections will outline the process for both and indicate where they may differ. You may start with one VM, then repeat for the other.

#### Creating the VMs
In VirtualBox, create a new virtual machine.

Under "Virtual machine name and operating system:"
- Give the VM a name, such as `linux01` for the Web Server and `linux02` for the Monitoring Server. If using different names, make sure you remember which role corresponds to each VM.
- For "ISO Image:" 
	- Select the Ubuntu Server 26.04 ISO file you downloaded.
	- Leave "proceed with Unattended Installation" checked.

Under "Set up unattended guest OS installation:"
- Enter `localadmin` as the username and choose a password. You will need to remember these credentials later to log into the machine.

Under "Specify virtual hardware:"
- For base memory:
	- On `linux01`: use 2 GB.
 	- On `linux02`: use 4 GB. Note that this VM requires additional resources to accommodate Zabbix Server.
- For CPUs:
	- On `linux01`: use 1 core.
 	- On `linux02`: use 2 cores.  
- You may leave "Use EFI" unchecked.

Under "Specify virtual disk:"
- For disk size:
	- On `linux01`: allocate 25 GB.
 	- On `linux02`: allocate 30 GB.

Then, click "Finish" to create the VM.

#### Network Adapters
After a VM has been created, you will need to configure its network adapters on VirtualBox. Right click the VM from the VirtualBox GUI, select Settings, and go to the "Network" tab. There, you should see a list of adapters.

Adapter 1 will allow the VM to access the internet. Use the following settings:
- Enable Network Adapter: Checked
- Attached to: NAT
- Virtual Cable Connected: Checked

On `linux02` only, you will need to enable Port Forwarding. Click "Port Forwarding" under Adapter 1 and fill the fields as follows:
- Name: `Zabbix-Web`
- Protocol: `TCP`
- Host IP: `127.0.0.1`
- Host Port: `8080`
- Guest Port: `80`
Once the Zabbix web frontend has been deployed, this will allow you to access it on a web browser from your host computer.

Adapter 2 will allow the VMs to communicate with each other through a virtual switch. Use the following settings:
- Enabled Network Adapter: Checked
- Attached to: Internal Network
- Name: `ANSIBLENET` (or any name of your choice, but it must be the same across all VMs)
- Promiscuous Mode: Deny
- Virtual Cable Connected: Checked

#### Accessing the Shell
To access the shell, you will first need to run the VM from VirtualBox. If this is the first time it's running, you may need to wait a few minutes for the OS to install.

Once the OS has booted, you may log into localadmin on the terminal. 

#### Bootstrapping
Unlike with `ansible01`, you will not need to clone anything from the repository. You simply need to ensure the VM can communicate with `ansible01` using SSH, and Ansible will take care of the rest later.

First, you will need to install and enable SSH.
```bash
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
```

Then, you will need to give the VM an IPv4 address on the internal network to allow it to communicate with other VMs.

Before configuring anything, view a list of available interfaces.
```bash
ip -br addr
```

Sample output (simplified to show IPv4 addresses only):
| Interface | State | Addresses | 
| --- | --- | --- |
| lo | UNKNOWN | 127.0.0.1/8 |
| enp0s3 | UP | 10.0.2.15/24 |
| enp0s8 | UP | - |

Here, `lo` is the loopback interface, and `enp0s3` is the NAT interface used to connect to the internet. If you do not see an interface without an IPv4 address (in this case, `enp0s8`), double check the network adapter settings in Virtual Box.

Then configure the right IPv4 address on the unconfigured interface using `netplan`.

On `linux01`:
```bash
sudo netplan set ethernets.enp0s8.dhcp4=false
sudo netplan set ethernets.enp0s8.addresses='[192.168.2.11/24]'
sudo netplan apply
```

On `linux02`:
```bash
sudo netplan set ethernets.enp0s8.dhcp4=false
sudo netplan set ethernets.enp0s8.addresses='[192.168.2.12/24]'
sudo netplan apply
```

Finally, you may verify the configuration.

To ensure the VM can reach `ansible01` (assuming it's running and already configured):
```bash
ping -c 4 192.168.2.1
```
