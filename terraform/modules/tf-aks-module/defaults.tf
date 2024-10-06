variable "prefix" {
  description = "Optional prefix to use before resource names. Should end in a hyphen"
  default     = null
  type        = string
}

variable "tags" {
  default     = {}
  description = "Map of tags"
  type        = map(any)
}

variable "instance_size" {
  default     = "Standard_B2ms"
  description = "Size to use for nodes in default node pool"
  type        = string
}

variable "node_count" {
  default     = 1
  description = "Number of AKS nodes"
  type        = number
}

variable "admin_username" {
  default     = "localadmin"
  description = "Admin Username for node pools"
  type        = string
}

variable "enable_private_dns_zone" {
  description = "Whether private DNS zone is created"
  type        = bool
  default     = true
}

variable "private_dns_zone_id" {
  description = "ID of private DNS zone"
  type        = string
  default     = ""
}

variable "public_dns_zone_id" {
  description = "ID of public DNS zone"
  type        = string
  default     = ""
}

variable "enable_public_dns_zone" {
  description = "Whether to create DNS resources"
  type        = bool
  default     = false
}

variable "private_cluster_enabled" {
  description = "Whether AKS Cluster is private"
  type        = bool
  default     = true
}

variable "default_node_rotation_name" {
  description = "Name to use for node roation group"
  type        = string
  default     = "temp"
}

variable "aks_admin_ips" {
  description = "IPs allowed to administer AKS Cluster"
  type        = map(any)
  default     = {}
}

variable "storage_account_name" {
  description = "Name of AKS storage account"
  type        = string
  default     = "aks-storage"
}

variable "storage_account_subnets" {
  description = "Azure subnets to allow access to storage account"
  type        = list(string)
  default     = []
}

variable "create_storage_account" {
  description = "Whether to create storage account"
  type        = bool
  default     = false
}

variable "kube_version" {
  description = "Set Kubernetes version to use"
  type        = string
  default     = "1.25"
}

variable "node_os_channel_upgrade" {
  description = "Node OS Upgrade Channel"
  type        = string
  default     = "None"
}

variable "automatic_channel_upgrade" {
  description = "Kubernetes Upgrade Channel"
  type        = string
  default     = "None"

}

variable "default_pool_max_pods" {
  description = "Max pods in default node pool"
  type        = string
  default     = "30"
}