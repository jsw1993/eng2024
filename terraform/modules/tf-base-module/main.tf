locals {
  vnet_size = split("/", var.address_space[0])[1]
  admin_ips = values(var.keyvault_ips)

}

data "azurerm_subscription" "current" {
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}vnet"
  address_space       = var.address_space
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet" "aks" {
  count                = var.enable_aks_subnet == true ? 1 : 0
  name                 = "${var.prefix}aks_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], var.aks_subnet_size - local.vnet_size, var.aks_subnet_netnum)]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "aks_control_plane" {
  count                = var.enable_aks_subnet == true ? 1 : 0
  name                 = "${var.prefix}aks_control_plane_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], var.aks_control_plane_subnet_size - local.vnet_size, var.aks_control_plane_subnet_netnum)]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}


resource "azurerm_subnet" "postgresql" {
  count = var.enable_postgresql_subnet == true ? 1 : 0

  name                 = "${var.prefix}postgresql_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], var.postgresql_subnet_size - local.vnet_size, var.postgresql_subnet_netnum)]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "database" {
  count = var.enable_database_subnet == true ? 1 : 0

  name                 = "${var.prefix}database_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], var.database_subnet_size - local.vnet_size, var.database_subnet_netnum)]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "wvd" {
  count                = var.enable_wvd_subnet == true ? 1 : 0
  name                 = "${var.prefix}wvd_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], var.wvd_subnet_size - local.vnet_size, var.wvd_subnet_netnum)]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}


resource "azurerm_subnet" "server" {
  count                = var.enable_server_subnet == true ? 1 : 0
  name                 = "${var.prefix}server_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], var.server_subnet_size - local.vnet_size, var.server_subnet_netnum)]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "public" {
  count                = var.enable_public_subnet == true ? 1 : 0
  name                 = "${var.prefix}public_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], var.public_subnet_size - local.vnet_size, var.public_subnet_netnum)]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "gateway" {
  count = var.enable_gateway_subnet == true ? 1 : 0

  name                 = "GatewaySubnet" # This name cannot be changed (it's an Azure thing)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], var.gateway_subnet_size - local.vnet_size, var.gateway_subnet_netnum)]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_key_vault" "keyvault" {
  # Purge protection disabled while under development
  name                        = "${var.prefix}infra-keyvault"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  enabled_for_deployment      = true
  tenant_id                   = data.azurerm_subscription.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false #tfsec:ignore:azure-keyvault-no-purge
  sku_name                    = "standard"
  tags                        = var.tags


  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = local.admin_ips
    virtual_network_subnet_ids = concat(
      compact([
        var.enable_aks_subnet ? azurerm_subnet.aks[0].id : null,
        var.enable_database_subnet ? azurerm_subnet.database[0].id : null,
        var.enable_wvd_subnet ? azurerm_subnet.wvd[0].id : null,
        var.enable_public_subnet ? azurerm_subnet.public[0].id : null,
        var.enable_server_subnet ? azurerm_subnet.server[0].id : null,
        var.enable_gateway_subnet ? azurerm_subnet.gateway[0].id : null
      ]),
      var.extra_kv_subnets
    )
  }
}

resource "azurerm_key_vault_access_policy" "keyvaultadmin" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = var.keyvault_admin_group_id

  key_permissions = [
    "Get", "Create", "Delete", "Update"
  ]

  secret_permissions = [
    "Get", "Set", "Purge", "Delete", "List"
  ]

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update"
  ]
}

resource "time_sleep" "key_vault_delay" {
  # After key_vault is created because the Azure API is slow there is a delay before access policies take effect. This prevents errors
  depends_on      = [azurerm_key_vault_access_policy.keyvaultadmin]
  create_duration = "30s"
}

resource "random_password" "windows-local-admin" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "wvd-local-admin" { #tfsec:ignore:azure-keyvault-ensure-secret-expiry
  name         = "${var.prefix}windows-local-admin"
  value        = random_password.windows-local-admin.result
  key_vault_id = azurerm_key_vault.keyvault.id
  content_type = "Windows VM Local Admin Password"
  depends_on   = [time_sleep.key_vault_delay]
}

resource "tls_private_key" "linux" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_ssh_public_key" "linux" {
  name                = "${var.prefix}linux"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_key          = tls_private_key.linux.public_key_openssh
  depends_on          = [time_sleep.key_vault_delay]
}

resource "azurerm_key_vault_secret" "linux" { #tfsec:ignore:azure-keyvault-ensure-secret-expiry
  name         = "${var.prefix}linux-private-key"
  value        = base64encode(tls_private_key.linux.private_key_pem)
  key_vault_id = azurerm_key_vault.keyvault.id
  content_type = "Base64 encoded SSH RSA private key"
  depends_on   = [time_sleep.key_vault_delay]
}

resource "azurerm_dns_zone" "public" {
  count               = var.enable_public_dns_zone == true ? 1 : 0
  name                = var.public_domain_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "private" {
  count               = var.enable_private_dns_zone == true ? 1 : 0
  name                = var.private_domain_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private" {
  count                 = var.enable_private_dns_zone == true ? 1 : 0
  name                  = "${var.prefix}private-dns-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = true
}