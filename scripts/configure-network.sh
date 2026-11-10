#!/bin/bash

# The user can either specify an interface or indicate that they want the script to detect it
interface="${1:-}"

case "$interface" in
    "") 
        echo -e "Example usage:\n"
        echo -e "Detect interface automatically:\n    ./scripts/configure-network.sh auto\n"
        echo -e "Use specified interface:\n    ./scripts/configure-network.sh enp0s8"
        exit 1
        ;;
    auto)
        # We want to find if there's an interface without an IPv4 address
        # as the NAT interface should already have one by default
        interface=""
        candidates=()  # Interfaces that may be the one we want to configure
        for path in /sys/class/net/*; do
            iface="${path##*/}"
            # Skip the loopback interface
            [[ "$iface" == "lo" ]] && continue

            # Check whether this interface is already using the intended IP
            if ip -4 addr show dev "$iface" | grep -Fq "inet 192.168.2.1/24"; then
                interface="$iface"
                break
            fi

            # Otherwise, check whether this interface has no IPv4 address
            if ! ip -4 addr show dev "$iface" | grep -q "inet "; then
                candidates+=("$iface")
            fi
        done

        if [[ -z "$interface" ]]; then  # If no interface that already has this IP was found, check the candidates (unconfigured interfaces)
            if [[ "${#candidates[@]}" -eq 1 ]]; then  # If only one candidate was found, choose it
                interface="${candidates[0]}"
            elif [[ "${#candidates[@]}" -gt 1 ]]; then  # If there were multiple candidates, prompt the user to select an interface manually
                echo "Multiple unconfigured interfaces found:"
                printf '%s\n' "${candidates[@]}"
                echo -e "Please specify the interface manually. Example:\n    ./scripts/configure-network.sh ${candidates[0]}"
                exit 1
            fi
        fi
        
        ;;
    *)  # User-specified interface
        valid_interface=false  # Does the interface exist?
        for iface in $(ls /sys/class/net); do
            if [[ "$interface" == "$iface" ]]; then
                valid_interface=true
                break
            fi
        done
        if [[ "$valid_interface" == false ]]; then
            echo "Error: interface $interface does not exist"
            exit 1
        fi
        ;;
esac

if [[ -n "$interface" ]]; then
    read -r -p "Are you sure you want to configure interface $interface with IP address 192.168.2.1/24? (y/n): " answer
    if [[ "$answer" == "y" ]]; then
        sudo netplan set "ethernets.${interface}.addresses=[192.168.2.1/24]"
        sudo netplan set "ethernets.${interface}.dhcp4=false"
        sudo netplan set "ethernets.${interface}.nameservers.addresses=[192.168.2.10]"
        sudo netplan set "ethernets.${interface}.nameservers.search=[~halcyon.internal]"
        sudo netplan apply
    else
        echo "Process has been canceled."
        exit 1
    fi
else  # Fails if automatic detection doesn't find an interface
    echo -e "No unconfigured interface could be found. You may view the current configuration with: \n ip -br addr"
fi
