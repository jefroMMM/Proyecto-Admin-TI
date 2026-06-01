variable "subscription_id" {
  description = "Azure subscription id"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "rg-proyecto-admin-ti"
}

variable "vnet_name" {
  type    = string
  default = "vnet-proyecto-admin-ti"
}

variable "subnet_name" {
  type    = string
  default = "subnet-app"
}

variable "public_ip_name" {
  type    = string
  default = "pip-proyecto-admin-ti"
}

variable "nsg_name" {
  type    = string
  default = "nsg-proyecto-admin-ti"
}

variable "nic_name" {
  type    = string
  default = "nic-proyecto-admin-ti"
}

variable "vm_name" {
  type    = string
  default = "vm-proyecto-admin-ti"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key content"
  type        = string
}

variable "vnet_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.20.1.0/24"
}

variable "enable_temp_app_ports" {
  description = "Enable temporary public ports 3000/8000"
  type        = bool
  default     = false
}
