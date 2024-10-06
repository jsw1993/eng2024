output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID of Azure VNET"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Name of Azure VNET"
}

output "gateway_subnet_id" {
  value       = var.enable_gateway_subnet ? azurerm_subnet.gateway[0].id : null
  description = "Subnet ID of gateway subnet"
}

output "public_subnet_id" {
  value       = var.enable_public_subnet ? azurerm_subnet.public[0].id : null
  description = "Subnet ID of public subnet"
}

output "aks_subnet_id" {
  value       = var.enable_aks_subnet ? azurerm_subnet.aks[0].id : null
  description = "Subnet ID of AKS subnet"
}

output "aks_control_plane_subnet_id" {
  value       = var.enable_aks_subnet ? azurerm_subnet.aks_control_plane[0].id : null
  description = "Subnet ID of AKS control plane subnet"
}

output "postgresql_subnet_id" {
  value       = var.enable_postgresql_subnet ? azurerm_subnet.postgresql[0].id : null
  description = "Subnet ID of postgresql subnet"
}

output "database_subnet_id" {
  value       = var.enable_database_subnet ? azurerm_subnet.database[0].id : null
  description = "Subnet ID of database subnet"
}

output "wvd_subnet_id" {
  value       = var.enable_wvd_subnet ? azurerm_subnet.wvd[0].id : null
  description = "Subnet ID of WVD subnet"
}

output "server_subnet_id" {
  value       = var.enable_server_subnet ? azurerm_subnet.server[0].id : null
  description = "Subnet ID of server subnet"
}


output "infra_keyvault_id" {
  value       = azurerm_key_vault.keyvault.id
  description = "ID of infra keyvault"
}

output "public_dns_zone_id" {
  value       = azurerm_dns_zone.public.*.id
  description = "ID of public DNS zone"
}

output "public_dns_zone_name" {
  value       = azurerm_dns_zone.public.*.name
  description = "Name of public DNS zone"
}

output "private_dns_zone_id" {
  value       = azurerm_private_dns_zone.private.*.id
  description = "ID of private DNS zone"
}

output "private_dns_zone_name" {
  value       = azurerm_private_dns_zone.private.*.name
  description = "Name of private DNS zone"
}


output "windows_local_admin_password" {
  value       = azurerm_key_vault_secret.wvd-local-admin.value
  description = "Windows local admin password"
  sensitive   = true
}

output "linux_public_key" {
  value       = azurerm_ssh_public_key.linux.public_key
  description = "Linux public key"
}
