# Backup y Restore

## Qué se respalda
- Base de datos PostgreSQL (dump `pg_dump -Fc`).
- Carpeta `backend/storage/audio`.
- `docker-compose.yml`, `docker-compose.prod.yml`, `.env.example`.
- Lista de variables requeridas (sin secretos).

## Scripts
- `scripts/backup.sh`
- `scripts/restore.sh`

## Frecuencia recomendada
- Ambiente académico/demo: diario antes de cambios importantes.
- Antes de cada deploy a `main`.

## Dónde guardar backups
- Local en `backups/` (generado por script).
- Recomendado copiar también fuera de la VPS (Blob Storage, otra VM o almacenamiento institucional).

## Comandos
```bash
chmod +x scripts/backup.sh scripts/restore.sh
./scripts/backup.sh
./scripts/restore.sh backups/backup-YYYYmmdd-HHMMSS.tar.gz
```

## Componentes críticos
- `postgres_data` (estado principal de entrevistas, reportes, embeddings, workflow).
- `backend/storage/audio` (audios originales y generados).
- Plantilla de variables para recuperar configuración (`.env.example`).

## Limitaciones
- No respalda `.env` real (intencional por seguridad).
- Restore reemplaza estado actual de DB y audio.
- Ejecutar restore sólo con confirmación y preferiblemente con servicios en mantenimiento.
