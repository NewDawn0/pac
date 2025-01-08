#!/usr/bin/env bash
TESTS=( "pac-c" "pac-cpp" "pac-rs" "pac-rs2" "pac-zig" )
ITERATIONS=1000

for test in "${TESTS[@]}"; do
    echo "Testing $test for $ITERATIONS iterations"
    {
        time for ((i=1; i<="$ITERATIONS"; i++)); do
            ./"$test" > /dev/null 2>&1
        done
    } 2>&1 | grep real
done
