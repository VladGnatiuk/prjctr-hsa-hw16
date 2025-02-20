#!/bin/bash

# Update package list and install hping3
apt-get update && apt-get install -y hping3

# Execute the UDP flood attack script
/kali/scripts/udp_flood.sh 