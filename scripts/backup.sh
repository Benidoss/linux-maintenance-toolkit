#!/bin/bash
set -euo pipefail


# --- Chargement de la configuration ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../config/maintenance.conf"

# --- 1. Vérifications de sécurité ---
# ${VAR:-} renvoie une valeur vide si VAR n'existe pas (au lieu de planter avec set -u)
if [ -z "${DOSSIER_SAUVEGARDES:-}" ] || [ -z "${DOSSIER_A_SAUVEGARDER:-}" ]; then
    echo "ERREUR : variables de configuration manquantes" >&2   # >&2 = afficher comme une erreur
    exit 1                                                       # arrêter le script en échec
fi

if [ ! -d "$DOSSIER_A_SAUVEGARDER" ]; then                       # ! = "si NE existe PAS"
    echo "ERREUR : le dossier $DOSSIER_A_SAUVEGARDER n'existe pas" >&2
    exit 1
fi

# --- 2. Créer le dossier des sauvegardes s'il n'existe pas ---
mkdir -p "$DOSSIER_SAUVEGARDES"

# --- 3. Créer l'archive datée ---
DATE=$(date "+%Y-%m-%d_%H%M%S")                                  # ex : 2026-10-31_020000
ARCHIVE="$DOSSIER_SAUVEGARDES/sauvegarde_$DATE.tar.gz"

# -C : se placer dans le dossier parent, pour que l'archive ne contienne pas tout le chemin /home/beni/...
tar -czf "$ARCHIVE" -C "$(dirname "$DOSSIER_A_SAUVEGARDER")" "$(basename "$DOSSIER_A_SAUVEGARDER")"
echo "Sauvegarde créée : $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"

# --- 4. Rotation : ne garder que les NB_SAUVEGARDES plus récentes ---
# ls -1t        : lister les archives, de la plus récente à la plus ancienne
# tail -n +8    : garder seulement celles à partir de la 8e (= les trop vieilles)
# xargs -r rm   : les supprimer (-r : ne rien faire si la liste est vide)
ls -1t "$DOSSIER_SAUVEGARDES"/sauvegarde_*.tar.gz \
    | tail -n +$((NB_SAUVEGARDES + 1)) \
    | xargs -r rm --

NB_RESTANT=$(ls -1 "$DOSSIER_SAUVEGARDES"/sauvegarde_*.tar.gz | wc -l)
echo "Rotation : $NB_RESTANT sauvegarde(s) conservée(s) sur $NB_SAUVEGARDES maximum"