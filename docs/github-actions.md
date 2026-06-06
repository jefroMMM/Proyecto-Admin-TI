# GitHub Actions (CI/CD)

## Workflows incluidos
- `/.github/workflows/ci.yml`: valida backend/frontend sin secretos de producción.
- `/.github/workflows/deploy.yml`: despliega a VPS por SSH solo cuando el workflow `CI` termina con éxito en `main`.

## Secrets requeridos
Configura en GitHub: `Settings > Secrets and variables > Actions > New repository secret`.

- `VPS_HOST`: `20.49.8.87`
- `VPS_USER`: `azureuser`
- `VPS_SSH_KEY`: contenido completo de la llave privada PEM
- `VPS_APP_DIR`: `/opt/proyecto-admin-ti`
- `VPS_PORT` (opcional): `22`
- `VPS_HEALTHCHECK_URL` (opcional): URL pública completa del endpoint estricto, por ejemplo `http://20.49.8.87:8000/healthcheck`. Si no se define, el workflow usa `http://VPS_HOST:8000/healthcheck`.

## Notas de seguridad
- No guardar llaves ni `.env` en el repositorio.
- El workflow crea `.env` desde plantilla solo si no existe; luego debes completarlo manualmente en VPS.
- Recomendado proteger rama `main` y exigir CI en PR.
- El despliegue automático queda bloqueado si CI falla.
- El despliegue usa exactamente el commit (`head_sha`) que fue validado por CI.
- El despliegue falla al final si `/healthcheck` no responde con HTTP 2xx.
