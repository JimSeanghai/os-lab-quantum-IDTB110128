#!/bin/bash

# Configuration
INVENTORY_FILE="inventory.txt"
LOG_FILE="sales.log"
STUDENT_ID="IDTB110128" 

# Logging Function
log_transaction() {
    local status=$1
    local user=$2
    local qty=$3
    echo "[$STUDENT_ID] [$status] $user bought $qty widgets" >> "$LOG_FILE"
}

# 1. Validation (The "Check")
if [ "$#" -ne 2 ]; then
    echo "Usage: buy_widget.sh <username> <quantity>"
    exit 1
fi

USERNAME=$1
QUANTITY=$2

if [[ ! "$QUANTITY" =~ ^[0-9]+$ ]] || [ "$QUANTITY" -le 0 ]; then
    echo "Error: Invalid quantity."
    exit 1
fi

# 2. The Mutex Lock (The "Patch")
# This block ensures that the Read, Calculate, and Write happen atomically.
(
    # Acquire an exclusive lock on file descriptor 200
    flock -x 200 

    # --- CRITICAL SECTION START ---
    CURRENT_STOCK=$(cat "$INVENTORY_FILE")

    if [ "$QUANTITY" -le "$CURRENT_STOCK" ]; then
        NEW_STOCK=$((CURRENT_STOCK - QUANTITY))
        # Update the file immediately while the lock is held
        echo "$NEW_STOCK" > "$INVENTORY_FILE"
        
        log_transaction "SUCCESS" "$USERNAME" "$QUANTITY"
        echo "Transaction Successful! Stock: $NEW_STOCK"
    else
        echo "Transaction Failed: Not enough inventory!"
        log_transaction "FAILURE" "$USERNAME" "$QUANTITY"
    fi
    # --- CRITICAL SECTION END ---

) 200> inventory.lock
