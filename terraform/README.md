# Terraform (Infraestructura como Código)

Este directorio modela la infraestructura mínima objetivo en Azure con `azurerm`.

## Alcance
- Resource Group
- Virtual Network + Subnet
- Public IP
- Network Security Group con reglas para 22/80/443
- Reglas opcionales temporales 3000/8000
- Network Interface
- Linux VM Ubuntu

## Importante para este proyecto
La VPS actual fue creada manualmente desde Azure Portal. Este Terraform sirve como evidencia IaC y base de estandarización.

No ejecutar `terraform apply` en producción sin revisar diferencias, porque podría crear o cambiar recursos fuera del estado actual.

## Comandos básicos
```bash
cd terraform
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=terraform.tfvars
```

## Uso recomendado con infraestructura existente
1. Usar este código como evidencia de diseño IaC.
2. Si deseas administrar recursos actuales con Terraform, primero importar recursos existentes.

Ejemplos de import (ajustar IDs reales):
```bash
terraform import azurerm_resource_group.this /subscriptions/<sub>/resourceGroups/<rg>
terraform import azurerm_public_ip.this /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/publicIPAddresses/<pip>
terraform import azurerm_linux_virtual_machine.this /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Compute/virtualMachines/<vm>
```

Después del import, ejecutar `terraform plan` y resolver drift antes de aplicar cambios.
