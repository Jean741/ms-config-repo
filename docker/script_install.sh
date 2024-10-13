#!/bin/bash

# Variables
DOWNLOAD_URL="https://raw.githubusercontent.com/Jean741/ms-config-repo/main/docker/docker-compose.yml"
DEST_DIR="/mnt"
NEW_FILE="$DEST_DIR/docker-compose.yml"
OLD_FILE="$DEST_DIR/docker-compose-old.yml"

# Téléchargement du nouveau fichier docker-compose.yml
echo "Téléchargement du nouveau fichier docker-compose.yml depuis GitHub..."
curl -o "$NEW_FILE" "$DOWNLOAD_URL"

# Vérifier si le téléchargement a réussi
if [ $? -eq 0 ]; then
  echo "Téléchargement réussi."

  # Renommer l'ancien fichier en old s'il existe
  if [ -f "$NEW_FILE" ]; then
    echo "Renommage de l'ancien fichier en docker-compose-old.yml..."
    mv "$NEW_FILE" "$OLD_FILE"
  fi

  # Essayer de déployer avec le nouveau fichier
  echo "Tentative de déploiement avec le nouveau fichier docker-compose.yml..."
  docker-compose -f "$NEW_FILE" up -d

  # Vérifier si l'installation a réussi
  if [ $? -eq 0 ]; then
    echo "Déploiement réussi avec le nouveau fichier."
  else
    echo "Échec du déploiement. Restauration de l'ancien fichier..."
    mv "$OLD_FILE" "$NEW_FILE"
    docker-compose -f "$NEW_FILE" up -d
  fi
else
  echo "Échec du téléchargement du fichier. Aucune modification effectuée."
fi
