terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "jswtfstate"
    container_name       = "tfstate"
    key                  = "eng2025.tfstate"
    # If running locally this needs to be true otherwise this should be false
    use_azuread_auth = true
    # If running via Atlantis using a MSI for auth this needs to be true otherwise this should be false.
    # Resource group also needs to be specified if using MSI
    use_msi             = false
    resource_group_name = "tf-state"
    subscription_id     = "a900772c-eb89-4701-9e62-1086c9c9354b"
    tenant_id           = "16098a1a-c0e4-4cf9-8888-ecdb7ecc1216"
  }
}

provider "azurerm" {
  features {}
  use_msi         = false
  subscription_id = "a900772c-eb89-4701-9e62-1086c9c9354b"
}


provider "azuread" {
    tenant_id           = "16098a1a-c0e4-4cf9-8888-ecdb7ecc1216"
}

data "azuread_client_config" "current" {}