# Guía de Despliegue en VPS Azure

## Contexto
- VPS: `20.49.8.87`
- Usuario sugerido: `azureuser`
- Llave local (Windows): `C:\Users\JefroMM\Downloads\vm-app-ia-01_key.pem`
- Carpeta remota recomendada: `/opt/proyecto-admin-ti`

## 1) Conectarse por SSH desde Windows PowerShell
```powershell
cd C:\Users\JefroMM\Downloads
icacls .\vm-app-ia-01_key.pem /inheritance:r
icacls .\vm-app-ia-01_key.pem /grant:r "$($env:USERNAME):(R)"
ssh -i .\vm-app-ia-01_key.pem azureuser@20.49.8.87
```

Si `icacls` falla, usa Git Bash o WSL para ajustar permisos con `chmod 600`.

## 2) Preparar servidor (Ubuntu)
```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release git

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
```

## 3) Clonar proyecto y configurar `.env`
```bash
sudo mkdir -p /opt/proyecto-admin-ti
sudo chown -R $USER:$USER /opt/proyecto-admin-ti
cd /opt/proyecto-admin-ti

git clone https://github.com/jefroMMM/Proyecto-Admin-TI.git .
cp .env.example .env
nano .env
```

## 4) Levantar app en producción
```bash
cd /opt/proyecto-admin-ti
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

## 5) Verificación y operación básica
```bash
docker ps
docker compose logs -f --tail=100
docker compose restart backend frontend
docker compose down
```

## 6) Actualizar despliegue manualmente
```bash
cd /opt/proyecto-admin-ti
git pull origin main
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
docker image prune -f
```
