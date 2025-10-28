#!/bin/bash

echo "Analyzing logs in $(pwd)..."
for file in *.log; do
  if [ -f "$file" ]; then
    echo "File: $file"
    echo "Lines: $(wc -l < $file)"
    echo "---"
  fi
done
