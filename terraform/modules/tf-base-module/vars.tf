variable "address_space" {
  description = "Address space for VNET"
  type        = list(any)
}

variable "location" {
  description = "Azure location for resources to be created in"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name to create resources in"
  type        = string
}

variable "keyvault_admin_group_id" {
  description = "Azure ID for group to have admin on keyvault"
  type        = string
}

variable "keyvault_ips" {
  description = "IPs allowed to access keyvault"
  type        = map(any)
}
