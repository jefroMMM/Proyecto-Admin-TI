output "public_ip" {
  value = azurerm_public_ip.this.ip_address
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.this.name
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "ssh_connection_command" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.this.ip_address}"
}
