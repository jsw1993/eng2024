locals {
  prefix              = "eng2024-"                             # Needs to end in hyphen, name used to prefix all resources
  primary-region      = "uksouth"                           # Azure egion to deploy infrastructure in 
  resource_group_name = "eng2024"                             # Name of resource group to deploy infrastructure into. Need owner rights and needs to exist
  admin_group_id      = "153f8e8f-3566-46f3-9dbf-5b97a8502721" # ID of Azure AD group to have admin rights on the environment
  address_space       = ["10.100.0.0/22"]                      # CIDR to use to build VNET
  private_domain_name = "vnet.eng.save-it.co.uk"                 # Private DNS zone to use for environment
  public_domain_name  = "eng.save-it.co.uk"                      # Public DNS zone to use for environment (need to add a delegation in parent domain)
  tags = {                                                     # Map of tags to use for all resources)
  }
  admin_ips = { # Map of IPs to have admin access to the environment
    "james-save-it" = "188.74.74.189"
  }
}

resource "azurerm_resource_group" "eng2025" {
  name     = local.resource_group_name
  location = "UK South"
}

module "base" {
  source                   = "./modules/tf-base-module"
  prefix                   = local.prefix
  location                 = local.primary-region
  resource_group_name      = azurerm_resource_group.eng2025.name
  address_space            = local.address_space
  keyvault_admin_group_id  = local.admin_group_id
  keyvault_ips             = local.admin_ips
  tags                     = local.tags
  public_domain_name       = local.public_domain_name
  private_domain_name      = local.private_domain_name
  enable_public_dns_zone   = true
  enable_private_dns_zone  = false
  enable_automation        = false
  enable_aks_subnet        = true
  enable_gateway_subnet    = false
  enable_wvd_subnet        = false
  enable_database_subnet   = false
  enable_server_subnet     = false
  enable_postgresql_subnet = false
}

module "aks_cluster" {
  source                      = "./modules/tf-aks-module"
  prefix                      = local.prefix
  location                    = local.primary-region
  resource_group_name         = local.resource_group_name
  tags                        = local.tags
  ssh_key                     = module.base.linux_public_key
  aks_subnet_id               = module.base.aks_subnet_id
  admin_group_ids             = [azuread_group.kubeadmin.object_id]
  enable_private_dns_zone     = false
  vnet_id                     = module.base.vnet_id
  enable_public_dns_zone      = true
  public_dns_zone_id          = module.base.public_dns_zone_id[0]
  fme_keyvault_id             = module.base.infra_keyvault_id
  private_cluster_enabled     = false
  instance_size               = "Standard_B2ms"
  node_count                  = 1
  aks_admin_ips               = local.admin_ips
  create_storage_account      = false
  storage_account_subnets     = [module.base.aks_subnet_id, module.base.public_subnet_id]
  aks_control_plane_subnet_id = module.base.aks_control_plane_subnet_id
  kube_version                = "1.28.12"
  node_os_channel_upgrade     = "NodeImage"
  automatic_channel_upgrade   = "patch"
  default_pool_max_pods       = "60"
}