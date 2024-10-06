resource "random_password" "fme_admin_password" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "fme_admin_password" { #tfsec:ignore:azure-keyvault-ensure-secret-expiry
  name         = "${var.prefix}aks-fme-admin-password"
  value        = random_password.fme_admin_password.result
  key_vault_id = var.fme_keyvault_id
  content_type = "FME Admin Password"
}
