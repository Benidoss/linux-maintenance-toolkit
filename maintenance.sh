#!/bin/bash
set -eup pipefail


# --- Chargement de la configuration ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"      # ici, SCRIPT_DIR = racine du projet
source "$SCRIPT_DIR/config/maintenance.conf"

# --- Créer le dossier du journal s'il n'existe pas ---
mkdir -p "$(dirname "$FICHIER_LOG")"

# --- Tout le bloc { ... } est envoyé à la fois à l'écran et dans le journal ---
# 2>&1      : inclure aussi les messages d'erreur
# tee -a    : afficher à l'écran ET ajouter (-a) à la fin du journal
{
    echo ""
    echo "========== Maintenance du $(date '+%Y-%m-%d %H:%M:%S') =========="
    "$SCRIPT_DIR/scripts/check_system.sh"
    "$SCRIPT_DIR/scripts/backup.sh"
    echo "Maintenance terminée."
} 2>&1 | tee -a "$FICHIER_LOG"