#!/bin/bash

# Validate input
LOG_FILE="${1:-access.log}"
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file '$LOG_FILE' not found!" >&2
    exit 1
fi

echo "=== TOP 10 CLIENT IPs ==="
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10

echo -e "\n=== TOP 10 ERROR REQUESTS (4xx/5xx) ==="
# $9 = status code. Filter 4xx/5xx, then show IP + request + status
awk '$9 ~ /^[45][0-9][0-9]$/ {print $1, $7, $9}' "$LOG_FILE" | \
    sort | uniq -c | sort -nr | head -n 10

echo -e "\n=== SUMMARY ==="
total=$(wc -l < "$LOG_FILE")
errors=$(awk '$9 ~ /^[45][0-9][0-9]$/' "$LOG_FILE" | wc -l)
error_rate=$(awk "BEGIN {printf \"%.2f\", $errors*100/$total}")
echo "Total requests: $total"
echo "Error requests: $errors ($error_rate%)"
