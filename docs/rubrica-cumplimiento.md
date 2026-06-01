# Resumen de Cumplimiento de Rúbrica

| Rubro | Evidencia (archivo) | Comando para mostrar | Qué decir en clase |
|---|---|---|---|
| Despliegue VPS /3 | `docs/deploy-vps.md`, `docker-compose.prod.yml` | `docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build` | Hay guía paso a paso desde servidor vacío y operación básica. |
| Docker Compose /2 | `docker-compose.yml`, `docker-compose.prod.yml` | `docker compose config` | Se separa desarrollo y producción; en prod no se publica 5432. |
| Persistencia /2 | `docker-compose.yml`, `backend/app/core/config.py`, `backend/app/audio/storage.py` | `docker volume ls`, `docker exec interviewer-postgres psql -U postgres -d interviewer -c "\dt"` | Persisten datos relacionales/vectoriales y archivos de audio. |
| CI/CD /3 | `.github/workflows/ci.yml`, `.github/workflows/deploy.yml`, `docs/github-actions.md` | Ver runs en pestaña Actions | CI valida backend/frontend; CD despliega por SSH con secretos. |
| Terraform /3 | `terraform/*` | `cd terraform && terraform init && terraform validate && terraform plan` | Infraestructura mínima Azure modelada como IaC. |
| Backup /1 | `scripts/backup.sh`, `scripts/restore.sh`, `docs/backup.md` | `./scripts/backup.sh` | Existe respaldo/restauración de DB + audio + archivos operativos. |
| Documentación /1 | `README.md` + `docs/*.md` | abrir README y docs | Documentación cubre operación, despliegue, IaC y continuidad. |

## Nota sobre Terraform y VPS actual
La VPS actual fue creada manualmente. Terraform se entrega como evidencia IaC y base para futura administración; no aplicar sin revisar/importar estado.
