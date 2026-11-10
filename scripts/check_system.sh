#!/bin/bash
set -euo pipefail

# Dossier où se trouve ce script (scripts/), puis chargement de la configuration
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../config/maintenance.conf"

reportDisk(){
    DISK=$(df / --output=pcent | tail -1 | tr -d ' %')

    if [ "$DISK"  -gt  "$DISK_SEUIL" ]; then
        echo "ALERTE"

    else
        echo "OK"

    fi

    echo "DISK Check is : $DISK"
}


reportMemory(){
    Memory=$(free | awk '/Mem:/ {printf "%d", $3/$2*100}')

    if [ "$Memory" -gt "$MEMORY_SEUIL" ]; then
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
reportMemory
displayCPU