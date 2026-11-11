# linux-maintenance-toolkit

Ce projet automatise la maintenance d'un serveur Linux grâce à des scripts Bash : surveillance du système, sauvegardes avec rotation et rapports planifiés avec cron.

Chaque nuit, le script :

## 1. Vérifie l'espace disque, la RAM et la charge processeur, avec une alerte au-delà d'un seuil ;
## 2. Sauvegarde un dossier dans une archive datée et ne garde que les 7 dernières ;
## 3. Ecrit un rapport dans un fichier journal.

# Fonctionnalités
- Surveillance du disque et de la mémoire, avec un état OK ou ALERTE selon un seuil réglable
- Affichage de la charge processeur
- Sauvegarde compressée et datée d'un dossier (tar.gz)
- Rotation automatique : seules les 7 sauvegardes les plus récentes sont conservées
- Rapport ajouté à un fichier journal à chaque exécution
- Exécution automatique chaque nuit avec cron
- Réglages centralisés dans un seul fichier de configuration
- Scripts vérifiés avec `shellcheck`

# Structure du projet


# Prérequis


# Installations
```bash
        git clone git@github.com:Benidoss/linux-maintenance-toolkit.git
        cd linux-maintenance-toolkit
        chmod +x maintenance.sh scripts/*.sh
```

# Configuration 


# Utilisation
Lancer la maintenance à la main :
```bash
./maintenance.sh
```

Le rapport s'affiche à l'écran et est ajouté au fichier journal :
```bash
    cat logs/maintenance.log
```

Chaque script peut aussi être lancé seul :
```bash
    ./scripts/check_system.sh                       # surveillance uniquement
    ./scripts/backup.sh                             # sauvegarde uniquement
```

# Automatisation avec `cron`

Pour lancer la maintenance chaque nuit à 2h, ouvrir la crontab avec crontab -e et ajouter :
```bash
    0 2 * * * /chemin/complet/vers/linux-maintenance-toolkit/maintenance.sh
```
Dans une crontab, il faut toujours utiliser un chemin complet : cron ne démarre pas dans le dossier personnel de l'utilisateur.

- Exemple de rapport

    ```
                ========== Maintenance du 2026-11-11 15:42:01 ==========
        === Rapport système du 2026-11-11 15:42 ===
        Disque (/)  : 48 %  -> OK
        Mémoire : 46 %  -> OK
        Charge CPU : 0.05
        Sauvegarde créée : /home/beni/backups/sauvegarde_2026-11-11_154201.tar.gz (184K)
        Rotation : 7 sauvegarde(s) conservée(s) sur 7 maximum
        Maintenance terminée.
    ```