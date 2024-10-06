variable "location" {
  description = "Azure location for resources to be created in"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name to create resources in"
  type        = string
}

variable "ssh_key" {
  description = "SSH Key set on AKS nodes"
  type        = string
}

variable "aks_subnet_id" {
  description = "AKS Subnet ID"
  type        = string
}

variable "aks_control_plane_subnet_id" {
  description = "AKS control plane Subnet ID"
  type        = string
}

variable "admin_group_ids" {
  description = "IDs of groups to have admin on the cluster"
  type        = list(any)
}

variable "vnet_id" {
  description = "ID of Azure VNET containing AKS subnet"
  type        = string

}

variable "fme_keyvault_id" {
  description = "ID of FME Keyvault"
  type        = string
  default     = "fme"

}
