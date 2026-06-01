# Checklist de Presentación (Administración de TI)

## Demostración técnica en clase
- Repositorio GitHub abierto (`main`, docs, workflows, terraform, scripts).
- SSH a VPS (`ssh -i ... azureuser@20.49.8.87`).
- `docker ps` mostrando `frontend`, `backend`, `postgres`.
- Aplicación funcionando en navegador (frontend y flujo base).
- `docker compose logs --tail=100` (backend/frontend).
- GitHub Actions CI exitoso.
- GitHub Actions Deploy disponible (manual o por push).
- Carpeta `terraform/` explicada (IaC).
- Scripts `scripts/backup.sh` y `scripts/restore.sh`.
- README con secciones de arquitectura, despliegue, CI/CD, IaC y backup.
- Explicación de persistencia: `postgres_data` y `storage/audio`.
