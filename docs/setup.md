## Introduction
**DISCLAIMER:** This document is a work in progress. Not every step has been tested thoroughly to ensure reproducibility. 

This guide will explain how you can set up and host this project on your personal computer.
### Overview of Virtual Machines

| VM Name   | Role                                |
| --------- | ----------------------------------- |
| ansible01 | Ansible Control Node                |
| linux01   | Nginx Intranet Web Server           |
| linux02   | Monitoring Server (planned)         |
| dc01      | Active Directory Domain Controller  |
| windows01 | Windows Enterprise Client (planned) |
### Basic System Requirements
This guide requires a computer with an x86-64 (AMD or Intel) processor running Windows, Linux, or macOS. Since it uses x86-64 operating system images, it is not intended for ARM-based processors, such as Apple Silicon Macs.

Your computer should have sufficient CPU cores, RAM, and storage space for each VM to run simultaneously. Additionally, an internet connection is required to clone the GitHub repository and install necessary packages.
### Installing VirtualBox

This project uses several virtual machines and could potentially work with different hypervisors, though this guide focuses exclusively on Oracle VirtualBox, which you may download [here.](https://www.virtualbox.org/wiki/Downloads) This lab was tested using version `7.2.20r175154` on Linux. Different versions of VirtualBox may have different interfaces but should nevertheless include all the necessary functionality.
## Using VirtualBox
After VirtualBox is successfully installed, you will need to create and configure each VM.
### Downloading ISO Files
Download [Ubuntu Server 26.04](https://ubuntu.com/download/server) from the official Ubuntu website. This lab was tested using **Ubuntu Server 26.04 LTS (64-bit)** which is also available [here](https://releases.ubuntu.com/26.04/).

Download [Windows Server 2025](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2025) from the official Microsoft Evaluation Center. This lab was tested using **Windows Server 2025 Standard Evaluation (Desktop Experience)**, installed from the 64-bit ISO.
### Creating The Ansible Control Node VM
In VirtualBox, create a new virtual machine.

Under "Virtual machine name and operating system:"
- Give the VM a name, such as `ansible01`
- For "ISO Image:" 
	- Select the Ubuntu Server 26.04 ISO file you downloaded.
	- Leave "proceed with Unattended Installation" checked.

Under "Set up unattended guest OS installation:"
- Enter `localadmin` as the username and choose a password. You will need to remember these credentials later to log into the machine.

Under "Specify virtual hardware:"
- For base memory, this project was tested with 2 GB, though the minimum required was 1.5 GB for this version. If using a different version of Ubuntu Server, you may refer to the official system requirements.
- For CPUs, a single CPU should be sufficient.
- You may leave "Use EFI" unchecked.

Under "Specify virtual disk:"
- For disk size, this project was tested with 25 GB, though the minimum required was 5 GB. 

Then, click "Finish" to create the VM.

### Configuring the Ansible Control Node
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
To access the shell, you will first need to run the VM from VirtualBox. If this is the first time it's running, you may need to wait a few minutes for the OS to install. If the VM becomes unresponsive, you may need to restart it.

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

Finally, generate an SSH key.
```bash
ssh-keygen -t ed25519
```
Press Enter to accept the default file location. You may optionally configure a passphrase to protect the private key, which is recommended.