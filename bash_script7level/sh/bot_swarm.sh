#!/bin/bash
# Target: Your partner's public_api
TARGET="/home/g11-lun-sokheng/bin/buy_widget"

echo "Launching Red Team swarm against partner..."

for i in {1..50}; do
    # Run THEIR script with YOUR bot name
    $TARGET "Jim_Bot_$i" 2 &
done
wait

echo "Attack complete. Checking partner's inventory..."
cat "/home/PARTNER_NAME/bin/bash_script7level/public_api/inventory.txt"
