# GitHub Actions (CI/CD)

## Workflows incluidos
- `/.github/workflows/ci.yml`: valida backend/frontend sin secretos de producción.
- `/.github/workflows/deploy.yml`: despliega a VPS por SSH en `push` a `main` o manual (`workflow_dispatch`).

## Secrets requeridos
Configura en GitHub: `Settings > Secrets and variables > Actions > New repository secret`.

- `VPS_HOST`: `20.49.8.87`
- `VPS_USER`: `azureuser`
- `VPS_SSH_KEY`: contenido completo de la llave privada PEM
- `VPS_APP_DIR`: `/opt/proyecto-admin-ti`
- `VPS_PORT` (opcional): `22`

## Notas de seguridad
- No guardar llaves ni `.env` en el repositorio.
- El workflow crea `.env` desde plantilla solo si no existe; luego debes completarlo manualmente en VPS.
- Recomendado proteger rama `main` y exigir CI en PR.
