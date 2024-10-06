resource "azuread_group" "kubeadmin" {
  display_name     = "eng2024-kubeadmin"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    data.azuread_client_config.current.object_id,

  ]
}