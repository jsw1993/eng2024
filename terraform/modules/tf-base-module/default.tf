variable "prefix" {
  description = "Optional prefix to use before resource names. Should end in a hyphen"
  default     = null
  type        = string
}

variable "aks_subnet_size" {
  description = "Size of AKS subnet"
  default     = 24
  type        = number
}

variable "aks_subnet_netnum" {
  description = "Offset from overall prefix for AKS subnet"
  default     = 0
  type        = number
}

variable "enable_aks_subnet" {
  description = "Create subnet for AKS"
  default     = true
  type        = bool
}

variable "aks_control_plane_subnet_size" {
  description = "Size of AKS control plane subnet"
  default     = 28
  type        = number
}

variable "aks_control_plane_subnet_netnum" {
  description = "Offset from overall prefix for AKS control plane subnet"
  default     = 31
  type        = number
}

variable "postgresql_subnet_size" {
  description = "Size of postgresql subnet"
  default     = 26
  type        = number
}

variable "postgresql_subnet_netnum" {
  description = "Offset from overall prefix for postgresql subnet"
  default     = 4
  type        = number
}

variable "enable_postgresql_subnet" {
  description = "Create subnet for PostgreSQL"
  default     = true
  type        = bool
}

variable "database_subnet_size" {
  description = "Size of database subnet"
  default     = 26
  type        = number
}

variable "database_subnet_netnum" {
  description = "Offset from overall prefix for postgresql subnet"
  default     = 5
  type        = number
}

variable "enable_database_subnet" {
  description = "Create subnet for database"
  default     = true
  type        = bool
}

variable "wvd_subnet_size" {
  description = "Size of WVD subnet"
  default     = 26
  type        = number
}

variable "wvd_subnet_netnum" {
  description = "Offset from overall prefix for WVD subnet"
  default     = 12
  type        = number
}

variable "enable_wvd_subnet" {
  description = "Create subnet for WVD"
  default     = true
  type        = bool
}

variable "server_subnet_size" {
  description = "Size of server subnet"
  default     = 26
  type        = number
}

variable "server_subnet_netnum" {
  description = "Offset from overall prefix for server subnet"
  default     = 13
  type        = number
}

variable "enable_server_subnet" {
  description = "Create subnet for Servers"
  default     = true
  type        = bool
}

variable "public_subnet_size" {
  description = "Size of public subnet"
  default     = 26
  type        = number
}

variable "public_subnet_netnum" {
  description = "Offset from overall prefix for public subnet"
  default     = 14
  type        = number
}

variable "enable_public_subnet" {
  description = "Create subnet for public resources"
  default     = true
  type        = bool
}


variable "gateway_subnet_size" {
  description = "Size of gateway subnet"
  default     = 26
  type        = number
}

variable "gateway_subnet_netnum" {
  description = "Offset from overall prefix for gateway subnet"
  default     = 15
  type        = number
}

variable "enable_gateway_subnet" {
  description = "Create Gateway Subnet"
  default     = true
  type        = bool
}


variable "tags" {
  description = "Map of tags"
  default     = {}
  type        = map(any)
}

variable "enable_public_dns_zone" {
  description = "Whether to create public DNS zone"
  default     = true
  type        = bool
}


variable "enable_private_dns_zone" {
  description = "Whether to create private DNS zone"
  default     = true
  type        = bool
}


variable "public_domain_name" {
  description = "Domain name to use for Azure public DNS zone"
  default     = ""
  type        = string
}

variable "private_domain_name" {
  description = "Domain name to use for Azure private DNS zone"
  default     = ""
  type        = string
}

variable "enable_automation" {
  description = "Enables automation jobs"
  default     = true
  type        = bool
}

variable "extra_kv_subnets" {
  description = "Extra subnets to be allowed access to infra kv"
  default     = []
  type        = list(any)
}