## Introduction
**DISCLAIMER:** This document is not yet finished and has not been tested for reproducibility. 

This guide will explain how you can set up and host this project on your personal computer.
### Overview of Virtual Machines

| VM Name   | Role                                         |
| --------- | -------------------------------------------- |
| ansible01 | Ansible Control Node                         |
| linux01   | Nginx Intranet Web Server                    |
| linux02   | Monitoring Server (planned)                  |
| dc01      | Active Directory Domain Controller (planned) |
| windows01 | Windows Enterprise Client (planned)          |

### Installing VirtualBox
This guide requires a computer with an x86-64 (AMD or Intel) processor running Windows, Linux, or macOS. Since it uses x86-64 operating system images, it is not intended for ARM-based processors, such as Apple Silicon Macs.

This project uses several virtual machines and could potentially work with different hypervisors, though this guide focuses exclusively on Oracle VirtualBox, which you may download [here.](https://www.virtualbox.org/wiki/Downloads) This lab was tested using version `7.2.20r175154` on Linux. Different versions of VirtualBox may have different interfaces but should nevertheless work.

### Basic System Requirements

Your computer should have sufficient CPU cores, RAM, and storage space for each VM to run simultaneously. Additionally, an internet connection is required to clone the GitHub repository and install necessary packages.

## Using VirtualBox
After VirtualBox is successfully installed, you will need to create and configure each VM.
### Downloading ISO Files
Download [Ubuntu Server 26.04](https://ubuntu.com/download/server) from the official Ubuntu website. This lab was tested using `ubuntu-26.04.1-live-server-amd64.iso` which is also available [here](https://releases.ubuntu.com/26.04/).
### Creating The Ansible Control Node VM
In VirtualBox, create a new virtual machine.

Under "Virtual machine name and operating system:"
- Give the VM a name, such as `ansible01`
- For "ISO Image:" 
	- Select the Ubuntu Server 26.04 ISO file you downloaded.
	- Leave "proceed with Unattended Installation" checked.

Under "Set up unattended guest OS installation:"
- Choose a username and password for the local admin account. You will need to remember these credentials later to log into the machine.

Under "Specify virtual hardware:"
- For base memory, this project was tested with 2 GB, though the minimum required was 1.5 GB for this version. If using a different version of Ubuntu Server, you may refer to the official system requirements.
- For CPUs, a single CPU should be sufficient.
- You may leave "Use EFI" unchecked.

Under "Specify virtual disk:"
- For disk size, this project was tested with 25 GB, though the minimum required was 5 GB. 

Then, click "Finish" to create the VM.
