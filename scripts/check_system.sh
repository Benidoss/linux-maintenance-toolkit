#!/bin/bash
set -euo pipefail

SUEIL=20

reportDisk(){
    DISK=$(df / --output=pcent | tail -1 | tr -d ' %')

    if [ "$DISK"  -gt  "$SUEIL" ]; then
        echo "ALERTE"

    else
        echo "OK"

    fi

    echo "DISK Check is : $DISK"
}


reportMemory(){
    Memory=$(free | awk '/Mem:/ {printf "%d", $3/$2*100}')

    if ["$Memory" -gt "$SUEIL"]; then
        echo "ALERTE"

    else
       echo "OK"

    fi

    echo "Memory Check is : $Memory"
}


displayCPU(){
    CPU=$(uptime | awk -F'load average: ' '{print $2}' | cut -d, -f1 )
    echo "CPU load Display $CPU"
}



echo "=== Rapport système du $(date '+%Y-%m-%d %H:%M') ==="
reportDisk
reportDisk
displayCPU