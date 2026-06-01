# AI Technical Interviewer Voice System

Plataforma full stack para entrevistas técnicas asistidas por IA con evaluación por plantilla, análisis de CV y entrevista por voz.

## Descripción del proyecto
- Frontend para reclutador y candidato.
- Backend API para gestión de entrevistas, scoring y reportes.
- Persistencia en PostgreSQL + pgvector.
- Integración con OpenAI, AssemblyAI y Cartesia.

## Arquitectura general
- `frontend/`: Next.js 15 + TypeScript.
- `backend/app/api`: rutas REST FastAPI.
- `backend/app/services`: lógica de negocio.
- `backend/app/repositories`: acceso a datos.
- `backend/app/models`: modelos SQLAlchemy.
- `backend/app/rag`: embeddings/retrieval con pgvector.
- `backend/app/audio`: STT/TTS y almacenamiento de audio.

## Arquitectura de infraestructura
- Docker Compose para `postgres`, `backend`, `frontend`.
- Modo desarrollo: `docker-compose.yml`.
- Modo producción: `docker-compose.yml` + `docker-compose.prod.yml`.
- IaC de referencia en `terraform/`.
- Mejora futura recomendada: Nginx reverse proxy para publicar `80/443` y ocultar `8000`.

## Servicios Docker
- `postgres` (pgvector/pg16)
- `backend` (FastAPI, puerto 8000)
- `frontend` (Next.js standalone, puerto 3000)

## Variables de entorno
Usar `.env.example` como plantilla:

```bash
cp .env.example .env
```

Variables clave:
- `OPENAI_API_KEY`
- `ASSEMBLYAI_API_KEY`
- `CARTESIA_API_KEY`
- `CARTESIA_VOICE_ID`
- `DATABASE_URL`
- `NEXT_PUBLIC_API_URL`
- `PUBLIC_BACKEND_URL`
- `BACKEND_CORS_ORIGINS`
- `AUDIO_STORAGE_DIR`

## Ejecución local
```bash
docker compose up --build
```

Accesos:
- Frontend: `http://localhost:3000`
- Backend: `http://localhost:8000`
- API docs: `http://localhost:8000/docs`

## Despliegue en VPS
Guía completa en:
- `docs/deploy-vps.md`

Comando de producción recomendado:
```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

## CI/CD
Workflows:
- `/.github/workflows/ci.yml`: validación backend/frontend y `docker compose config`.
- `/.github/workflows/deploy.yml`: despliegue por SSH a VPS en push a `main` o manual.

Documentación:
- `docs/github-actions.md`

## Terraform / IaC
Carpeta:
- `terraform/`

Incluye recursos Azure mínimos: RG, red, subnet, IP pública, NSG, NIC y VM Linux.

Ver:
- `terraform/README.md`

## Persistencia
- Base de datos: volumen `postgres_data`.
- Audio: `backend/storage/audio` (en prod con volumen dedicado).
- Estado de workflow y embeddings en PostgreSQL.

## Backup y continuidad
Scripts:
- `scripts/backup.sh`
- `scripts/restore.sh`

Documento operativo:
- `docs/backup.md`

## Operación básica
```bash
docker ps
docker compose logs -f --tail=100
docker compose restart backend frontend
docker compose down
```

Actualizar despliegue:
```bash
git pull origin main
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
docker image prune -f
```

## Troubleshooting
- Error de credenciales TTS/STT/LLM: revisar `.env`.
- CORS: ajustar `BACKEND_CORS_ORIGINS`.
- Reinicio limpio de contenedores:
  ```bash
  docker compose down
  docker compose up --build
  ```

## Evidencia para rúbrica
- Checklist presentación: `docs/checklist-presentacion.md`
- Matriz de cumplimiento: `docs/rubrica-cumplimiento.md`
- Guía VPS: `docs/deploy-vps.md`
- CI/CD: `.github/workflows/*` y `docs/github-actions.md`
- IaC: `terraform/*`
- Backup: `scripts/*` y `docs/backup.md`
