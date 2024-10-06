data "azurerm_subscription" "current" {
}

locals {
  aks_admin_ips_cidr = formatlist("%s/32", values(var.aks_admin_ips))
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "aks-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}

#tfsec:ignore:azure-container-logging
resource "azurerm_kubernetes_cluster" "aks" {
  name                         = "${var.prefix}aks"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  dns_prefix                   = "${var.prefix}aks"
  kubernetes_version           = var.kube_version
  oidc_issuer_enabled          = true
  node_os_upgrade_channel      = var.node_os_channel_upgrade
  automatic_upgrade_channel    = var.automatic_channel_upgrade
  image_cleaner_interval_hours = 48
  # workload_identity_enabled = true

  maintenance_window_auto_upgrade {
    frequency   = "RelativeMonthly"
    interval    = 1
    day_of_week = "Sunday"
    start_time  = "23:00"
    utc_offset  = "+00:00"
    week_index  = "Last"
    duration    = 4
  }

  maintenance_window_node_os {
    frequency   = "RelativeMonthly"
    interval    = 1
    day_of_week = "Monday"
    start_time  = "03:00"
    utc_offset  = "+00:00"
    week_index  = "Last"
    duration    = 4
  }

  default_node_pool {
    name                        = "default"
    node_count                  = var.node_count
    vm_size                     = var.instance_size
    vnet_subnet_id              = var.aks_subnet_id
    temporary_name_for_rotation = var.default_node_rotation_name
    max_pods                    = var.default_pool_max_pods
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "azure"
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.ssh_key
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  private_cluster_enabled = var.private_cluster_enabled
  tags                    = var.tags

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.admin_group_ids
    azure_rbac_enabled     = true
  }

  local_account_disabled = true

  api_server_access_profile {
    authorized_ip_ranges = local.aks_admin_ips_cidr
    # subnet_id                = var.aks_control_plane_subnet_id
    # vnet_integration_enabled = true
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
  depends_on = [
    azurerm_role_assignment.aks_control_plane_subnet_access,
    azurerm_role_assignment.aks_subnet_access
  ]
}

resource "azurerm_role_assignment" "aks_dns_contributor" {
  count                = var.enable_private_dns_zone == true ? 1 : 0
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
  scope                = var.private_dns_zone_id
}

resource "azurerm_role_definition" "dns_private_zone_reader" {
  name        = "${var.prefix}private_dns_reader"
  scope       = var.vnet_id
  description = "Has rights to read private DNS zones"

  permissions {
    actions = [
      "Microsoft.Network/privateDnsZones/read"
    ]
  }
  assignable_scopes = [
    var.vnet_id
  ]
}

resource "azurerm_role_assignment" "aks_dns_private_zone_reader" {
  scope                = var.vnet_id
  role_definition_name = azurerm_role_definition.dns_private_zone_reader.name
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_role_assignment" "aks_subnet_access" {
  scope                = var.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_role_assignment" "aks_control_plane_subnet_access" {
  scope                = var.aks_control_plane_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_role_assignment" "aks_public_dns_contributor" {
  count                = var.enable_public_dns_zone == true ? 1 : 0
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  scope                = var.public_dns_zone_id
}

resource "azurerm_key_vault_access_policy" "aks-keyvault-read" {
  key_vault_id = var.fme_keyvault_id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  key_permissions = [
    "Get"
  ]

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "GetIssuers",
    "List",
    "ListIssuers",
  ]
}