#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Uso: $0 /ruta/al/backup-YYYYmmdd-HHMMSS.tar.gz"
  exit 1
fi

BACKUP_FILE="$1"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
RESTORE_DIR="$PROJECT_DIR/backups/restore-tmp"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "No existe el archivo: $BACKUP_FILE"
  exit 1
fi

echo "ADVERTENCIA: Este proceso sobrescribirá base de datos y storage/audio."
read -r -p "Escribe RESTORE para continuar: " CONFIRM
if [ "$CONFIRM" != "RESTORE" ]; then
  echo "Operación cancelada"
  exit 1
fi

rm -rf "$RESTORE_DIR"
mkdir -p "$RESTORE_DIR"
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"

EXTRACTED_DIR="$(find "$RESTORE_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
if [ -z "$EXTRACTED_DIR" ]; then
  echo "No se pudo identificar contenido del backup"
  exit 1
fi

cd "$PROJECT_DIR"

# Restaurar audio
if [ -d "$EXTRACTED_DIR/backend/storage/audio" ]; then
  mkdir -p "$PROJECT_DIR/backend/storage"
  rm -rf "$PROJECT_DIR/backend/storage/audio"
  cp -a "$EXTRACTED_DIR/backend/storage/audio" "$PROJECT_DIR/backend/storage/"
fi

# Restaurar base PostgreSQL
if [ -f "$EXTRACTED_DIR/postgres.dump" ]; then
  docker compose exec -T postgres psql -U postgres -d interviewer -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
  docker compose exec -T postgres pg_restore -U postgres -d interviewer < "$EXTRACTED_DIR/postgres.dump"
fi

rm -rf "$RESTORE_DIR"
echo "Restore completado"
