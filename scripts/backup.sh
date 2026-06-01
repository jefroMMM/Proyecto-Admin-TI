#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="${PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$PROJECT_DIR/backups"
WORK_DIR="$BACKUP_ROOT/backup-$TIMESTAMP"
ARCHIVE="$BACKUP_ROOT/backup-$TIMESTAMP.tar.gz"

mkdir -p "$WORK_DIR"

cd "$PROJECT_DIR"

# Backup de PostgreSQL (formato custom)
docker compose exec -T postgres pg_dump -U postgres -d interviewer -Fc > "$WORK_DIR/postgres.dump"

# Backup de storage/audio si existe
if [ -d "$PROJECT_DIR/backend/storage/audio" ]; then
  mkdir -p "$WORK_DIR/backend/storage"
  cp -a "$PROJECT_DIR/backend/storage/audio" "$WORK_DIR/backend/storage/"
fi

# Archivos de operación
cp "$PROJECT_DIR/docker-compose.yml" "$WORK_DIR/" || true
cp "$PROJECT_DIR/docker-compose.prod.yml" "$WORK_DIR/" || true
cp "$PROJECT_DIR/.env.example" "$WORK_DIR/" || true

# Lista de variables (sin valores secretos)
cat > "$WORK_DIR/env-required-variables.txt" <<'VARS'
OPENAI_API_KEY
ASSEMBLYAI_API_KEY
CARTESIA_API_KEY
CARTESIA_VOICE_ID
DATABASE_URL
NEXT_PUBLIC_API_URL
PUBLIC_BACKEND_URL
BACKEND_CORS_ORIGINS
FRONTEND_PORT
AUDIO_STORAGE_DIR
VARS

tar -czf "$ARCHIVE" -C "$BACKUP_ROOT" "backup-$TIMESTAMP"
rm -rf "$WORK_DIR"

echo "Backup generado: $ARCHIVE"
