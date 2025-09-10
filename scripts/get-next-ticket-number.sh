#!/bin/bash

# Get the next sequential ticket number for PHYSIOAI project
# Usage: ./scripts/get-next-ticket-number.sh

# Get max ticket number (returns empty if no tickets exist)
MAX_TICKET=$(find docs/product/backlog -name "PHSIOAI-*" -exec basename {} \; | grep -o 'PHSIOAI-[0-9]\+' | sed 's/PHSIOAI-//' | sort -n | tail -1)

# If empty, start with 001, otherwise increment by 1
if [ -z "$MAX_TICKET" ]; then
  NEXT_TICKET="001"
else
  NEXT_TICKET=$(printf "%03d" $((10#$MAX_TICKET + 1)))
fi

echo "Next ticket number: PHSIOAI-$NEXT_TICKET"