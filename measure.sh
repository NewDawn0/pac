FILE="./result/bin/pac"
ITERATIONS=1000
echo "Testing $FILE for $ITERATIONS iterations"
{
    time for ((i=1; i<="$ITERATIONS"; i++)); do
        ./"$FILE" > /dev/null 2>&1
    done
} 2>&1 | grep real
