#!/bin/bash

interface=""  # The internal network interface

# We want to find if there's an interface without an IPv4 address
# as the NAT interface should already have one by default
for iface in $(ls /sys/class/net); do
    # Skip the loopback interface
    [[ "$iface" == "lo" ]] && continue

    # Check whether this interface has an IPv4 address
    if ! ip -4 addr show dev "$iface" | grep -q "inet "; then
        interface="$iface"
        break
    fi
done

if [[ -n "$interface" ]]; then
    read -r -p "Are you sure you want to configure interface $interface with IP address 192.168.2.1/24? (y/n): " answer
    if [[ "$answer" == "y" ]]; then
        sudo netplan set "ethernets.${interface}.addresses=[192.168.2.1/24]"
        sudo netplan set "ethernets.${interface}.dhcp4=false"
        sudo netplan apply
    else
        echo "Process has been canceled."
        exit 1
    fi
else
    echo -e "No unconfigured interface could be found. You may view the current configuration with: \n ip -br addr"
fi
