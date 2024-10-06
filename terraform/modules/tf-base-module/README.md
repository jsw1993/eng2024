# Overview
This module creates the base Azure infrastructure for the demo environment. It is expected these resources are always created.

The resources created by this module have no ongoing cost (cost is usage based if any cost at all.)

# Structure
- default.tf: Contains any variables that have a default set
- main.tf: Contains local vars and any resources
- variables.tf: Contains any required variables
- test: Contains mock files to run TF validate against

<!-- BEGIN_TF_DOCS -->
# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Address space for VNET | `list(any)` | n/a | yes |
| <a name="input_aks_control_plane_subnet_netnum"></a> [aks\_control\_plane\_subnet\_netnum](#input\_aks\_control\_plane\_subnet\_netnum) | Offset from overall prefix for AKS control plane subnet | `number` | `31` | no |
| <a name="input_aks_control_plane_subnet_size"></a> [aks\_control\_plane\_subnet\_size](#input\_aks\_control\_plane\_subnet\_size) | Size of AKS control plane subnet | `number` | `28` | no |
| <a name="input_aks_subnet_netnum"></a> [aks\_subnet\_netnum](#input\_aks\_subnet\_netnum) | Offset from overall prefix for AKS subnet | `number` | `0` | no |
| <a name="input_aks_subnet_size"></a> [aks\_subnet\_size](#input\_aks\_subnet\_size) | Size of AKS subnet | `number` | `24` | no |
| <a name="input_database_subnet_netnum"></a> [database\_subnet\_netnum](#input\_database\_subnet\_netnum) | Offset from overall prefix for postgresql subnet | `number` | `5` | no |
| <a name="input_database_subnet_size"></a> [database\_subnet\_size](#input\_database\_subnet\_size) | Size of database subnet | `number` | `26` | no |
| <a name="input_enable_aks_subnet"></a> [enable\_aks\_subnet](#input\_enable\_aks\_subnet) | Create subnet for AKS | `bool` | `true` | no |
| <a name="input_enable_automation"></a> [enable\_automation](#input\_enable\_automation) | Enables automation jobs | `bool` | `true` | no |
| <a name="input_enable_database_subnet"></a> [enable\_database\_subnet](#input\_enable\_database\_subnet) | Create subnet for database | `bool` | `true` | no |
| <a name="input_enable_gateway_subnet"></a> [enable\_gateway\_subnet](#input\_enable\_gateway\_subnet) | Create Gateway Subnet | `bool` | `true` | no |
| <a name="input_enable_postgresql_subnet"></a> [enable\_postgresql\_subnet](#input\_enable\_postgresql\_subnet) | Create subnet for PostgreSQL | `bool` | `true` | no |
| <a name="input_enable_private_dns_zone"></a> [enable\_private\_dns\_zone](#input\_enable\_private\_dns\_zone) | Whether to create private DNS zone | `bool` | `true` | no |
| <a name="input_enable_public_dns_zone"></a> [enable\_public\_dns\_zone](#input\_enable\_public\_dns\_zone) | Whether to create public DNS zone | `bool` | `true` | no |
| <a name="input_enable_public_subnet"></a> [enable\_public\_subnet](#input\_enable\_public\_subnet) | Create subnet for public resources | `bool` | `true` | no |
| <a name="input_enable_server_subnet"></a> [enable\_server\_subnet](#input\_enable\_server\_subnet) | Create subnet for Servers | `bool` | `true` | no |
| <a name="input_enable_wvd_subnet"></a> [enable\_wvd\_subnet](#input\_enable\_wvd\_subnet) | Create subnet for WVD | `bool` | `true` | no |
| <a name="input_extra_kv_subnets"></a> [extra\_kv\_subnets](#input\_extra\_kv\_subnets) | Extra subnets to be allowed access to infra kv | `list(any)` | `[]` | no |
| <a name="input_gateway_subnet_netnum"></a> [gateway\_subnet\_netnum](#input\_gateway\_subnet\_netnum) | Offset from overall prefix for gateway subnet | `number` | `15` | no |
| <a name="input_gateway_subnet_size"></a> [gateway\_subnet\_size](#input\_gateway\_subnet\_size) | Size of gateway subnet | `number` | `26` | no |
| <a name="input_keyvault_admin_group_id"></a> [keyvault\_admin\_group\_id](#input\_keyvault\_admin\_group\_id) | Azure ID for group to have admin on keyvault | `string` | n/a | yes |
| <a name="input_keyvault_ips"></a> [keyvault\_ips](#input\_keyvault\_ips) | IPs allowed to access keyvault | `map(any)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location for resources to be created in | `string` | n/a | yes |
| <a name="input_postgresql_subnet_netnum"></a> [postgresql\_subnet\_netnum](#input\_postgresql\_subnet\_netnum) | Offset from overall prefix for postgresql subnet | `number` | `4` | no |
| <a name="input_postgresql_subnet_size"></a> [postgresql\_subnet\_size](#input\_postgresql\_subnet\_size) | Size of postgresql subnet | `number` | `26` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Optional prefix to use before resource names. Should end in a hyphen | `string` | `null` | no |
| <a name="input_private_domain_name"></a> [private\_domain\_name](#input\_private\_domain\_name) | Domain name to use for Azure private DNS zone | `string` | `""` | no |
| <a name="input_public_domain_name"></a> [public\_domain\_name](#input\_public\_domain\_name) | Domain name to use for Azure public DNS zone | `string` | `""` | no |
| <a name="input_public_subnet_netnum"></a> [public\_subnet\_netnum](#input\_public\_subnet\_netnum) | Offset from overall prefix for public subnet | `number` | `14` | no |
| <a name="input_public_subnet_size"></a> [public\_subnet\_size](#input\_public\_subnet\_size) | Size of public subnet | `number` | `26` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name to create resources in | `string` | n/a | yes |
| <a name="input_server_subnet_netnum"></a> [server\_subnet\_netnum](#input\_server\_subnet\_netnum) | Offset from overall prefix for server subnet | `number` | `13` | no |
| <a name="input_server_subnet_size"></a> [server\_subnet\_size](#input\_server\_subnet\_size) | Size of server subnet | `number` | `26` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags | `map(any)` | `{}` | no |
| <a name="input_wvd_subnet_netnum"></a> [wvd\_subnet\_netnum](#input\_wvd\_subnet\_netnum) | Offset from overall prefix for WVD subnet | `number` | `12` | no |
| <a name="input_wvd_subnet_size"></a> [wvd\_subnet\_size](#input\_wvd\_subnet\_size) | Size of WVD subnet | `number` | `26` | no |
# Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.automation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.keyvaultadmin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.wvd-local-admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_private_dns_zone.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_role_assignment.automation-aks-operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.automation-db-operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.automation-vm-operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.aks-operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.db-operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.vm-operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_ssh_public_key.linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ssh_public_key) | resource |
| [azurerm_subnet.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.postgresql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.wvd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_password.windows-local-admin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_sleep.key_vault_delay](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.linux](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
# Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_control_plane_subnet_id"></a> [aks\_control\_plane\_subnet\_id](#output\_aks\_control\_plane\_subnet\_id) | Subnet ID of AKS control plane subnet |
| <a name="output_aks_subnet_id"></a> [aks\_subnet\_id](#output\_aks\_subnet\_id) | Subnet ID of AKS subnet |
| <a name="output_azure_automation_account_name"></a> [azure\_automation\_account\_name](#output\_azure\_automation\_account\_name) | Name of Azure automation account |
| <a name="output_database_subnet_id"></a> [database\_subnet\_id](#output\_database\_subnet\_id) | Subnet ID of database subnet |
| <a name="output_gateway_subnet_id"></a> [gateway\_subnet\_id](#output\_gateway\_subnet\_id) | Subnet ID of gateway subnet |
| <a name="output_infra_keyvault_id"></a> [infra\_keyvault\_id](#output\_infra\_keyvault\_id) | ID of infra keyvault |
| <a name="output_linux_public_key"></a> [linux\_public\_key](#output\_linux\_public\_key) | Linux public key |
| <a name="output_postgresql_subnet_id"></a> [postgresql\_subnet\_id](#output\_postgresql\_subnet\_id) | Subnet ID of postgresql subnet |
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | ID of private DNS zone |
| <a name="output_private_dns_zone_name"></a> [private\_dns\_zone\_name](#output\_private\_dns\_zone\_name) | Name of private DNS zone |
| <a name="output_public_dns_zone_id"></a> [public\_dns\_zone\_id](#output\_public\_dns\_zone\_id) | ID of public DNS zone |
| <a name="output_public_dns_zone_name"></a> [public\_dns\_zone\_name](#output\_public\_dns\_zone\_name) | Name of public DNS zone |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | Subnet ID of public subnet |
| <a name="output_server_subnet_id"></a> [server\_subnet\_id](#output\_server\_subnet\_id) | Subnet ID of server subnet |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID of Azure VNET |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Name of Azure VNET |
| <a name="output_windows_local_admin_password"></a> [windows\_local\_admin\_password](#output\_windows\_local\_admin\_password) | Windows local admin password |
| <a name="output_wvd_subnet_id"></a> [wvd\_subnet\_id](#output\_wvd\_subnet\_id) | Subnet ID of WVD subnet |

<!-- END_TF_DOCS -->
# Automation
The following automations are added by this module:
- deallocate-vms: Runs every hour to deallocate any VMs that are stopped