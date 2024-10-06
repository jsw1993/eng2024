# Overview
This module creates an AKS Private Cluster

# Structure
- default.tf: Contains any variables that have a default set
- main.tf: Contains local vars and any resources
- variables.tf: Contains any required variables

<!-- BEGIN_TF_DOCS -->
# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_ids"></a> [admin\_group\_ids](#input\_admin\_group\_ids) | IDs of groups to have admin on the cluster | `list(any)` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin Username for node pools | `string` | `"localadmin"` | no |
| <a name="input_aks_admin_ips"></a> [aks\_admin\_ips](#input\_aks\_admin\_ips) | IPs allowed to administer AKS Cluster | `map(any)` | `{}` | no |
| <a name="input_aks_control_plane_subnet_id"></a> [aks\_control\_plane\_subnet\_id](#input\_aks\_control\_plane\_subnet\_id) | AKS control plane Subnet ID | `string` | n/a | yes |
| <a name="input_aks_subnet_id"></a> [aks\_subnet\_id](#input\_aks\_subnet\_id) | AKS Subnet ID | `string` | n/a | yes |
| <a name="input_automatic_channel_upgrade"></a> [automatic\_channel\_upgrade](#input\_automatic\_channel\_upgrade) | Kubernetes Upgrade Channel | `string` | `"None"` | no |
| <a name="input_create_storage_account"></a> [create\_storage\_account](#input\_create\_storage\_account) | Whether to create storage account | `bool` | `false` | no |
| <a name="input_default_node_rotation_name"></a> [default\_node\_rotation\_name](#input\_default\_node\_rotation\_name) | Name to use for node roation group | `string` | `"temp"` | no |
| <a name="input_default_pool_max_pods"></a> [default\_pool\_max\_pods](#input\_default\_pool\_max\_pods) | Max pods in default node pool | `string` | `"30"` | no |
| <a name="input_enable_private_dns_zone"></a> [enable\_private\_dns\_zone](#input\_enable\_private\_dns\_zone) | Whether private DNS zone is created | `bool` | `true` | no |
| <a name="input_enable_public_dns_zone"></a> [enable\_public\_dns\_zone](#input\_enable\_public\_dns\_zone) | Whether to create DNS resources | `bool` | `false` | no |
| <a name="input_fme_keyvault_id"></a> [fme\_keyvault\_id](#input\_fme\_keyvault\_id) | ID of FME Keyvault | `string` | `"fme"` | no |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | Size to use for nodes in default node pool | `string` | `"Standard_B2ms"` | no |
| <a name="input_kube_version"></a> [kube\_version](#input\_kube\_version) | Set Kubernetes version to use | `string` | `"1.25"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location for resources to be created in | `string` | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of AKS nodes | `number` | `1` | no |
| <a name="input_node_os_channel_upgrade"></a> [node\_os\_channel\_upgrade](#input\_node\_os\_channel\_upgrade) | Node OS Upgrade Channel | `string` | `"None"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Optional prefix to use before resource names. Should end in a hyphen | `string` | `null` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Whether AKS Cluster is private | `bool` | `true` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | ID of private DNS zone | `string` | `""` | no |
| <a name="input_public_dns_zone_id"></a> [public\_dns\_zone\_id](#input\_public\_dns\_zone\_id) | ID of public DNS zone | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name to create resources in | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Key set on AKS nodes | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of AKS storage account | `string` | `"aks-storage"` | no |
| <a name="input_storage_account_subnets"></a> [storage\_account\_subnets](#input\_storage\_account\_subnets) | Azure subnets to allow access to storage account | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags | `map(any)` | `{}` | no |
| <a name="input_vnet_id"></a> [vnet\_id](#input\_vnet\_id) | ID of Azure VNET containing AKS subnet | `string` | n/a | yes |
# Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.aks-keyvault-read](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.fme_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_role_assignment.aks_control_plane_subnet_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_dns_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_dns_private_zone_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_public_dns_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_storage_account_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_subnet_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.dns_private_zone_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_user_assigned_identity.aks_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_password.fme_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
# Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_cluster_id"></a> [aks\_cluster\_id](#output\_aks\_cluster\_id) | n/a |

<!-- END_TF_DOCS -->