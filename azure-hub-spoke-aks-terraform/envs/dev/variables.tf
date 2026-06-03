variable "environment" {
  type        = string
  description = "Environment name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}

variable "hub_vnet_address_space" {
  type        = list(string)
  description = "Hub VNet address space."
}

variable "spoke_vnet_address_space" {
  type        = list(string)
  description = "Spoke VNet address space."
}

variable "hub_subnet_address_prefixes" {
  type        = list(string)
  description = "Hub shared subnet address prefixes."
}

variable "spoke_subnet_address_prefixes" {
  type        = list(string)
  description = "Spoke subnet address prefixes."
}

variable "azure_firewall_subnet_address_prefixes" {
  type        = list(string)
  description = "Azure Firewall subnet address prefixes."
}

variable "azure_firewall_sku_tier" {
  type        = string
  description = "Azure Firewall SKU tier."
  default     = "Standard"
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "purge_protection_enabled" {
  type    = bool
  default = false
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "key_vault_private_dns_zone_name" {
  type    = string
  default = "privatelink.vaultcore.azure.net"
}

variable "acr_private_dns_zone_name" {
  type    = string
  default = "privatelink.azurecr.io"
}

variable "private_cluster_enabled" {
  type    = bool
  default = true
}

variable "aks_node_count" {
  type    = number
  default = 2
}

variable "aks_vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

variable "aks_service_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "aks_dns_service_ip" {
  type    = string
  default = "10.2.0.10"
}

variable "enable_agic" {
  type    = bool
  default = true
}

variable "app_gateway_subnet_address_prefixes" {
  description = "Application Gateway subnet CIDR"
  type        = list(string)
}

variable "app_gateway_sku_name" {
  description = "Application Gateway SKU name"
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_sku_tier" {
  description = "Application Gateway SKU tier"
  type        = string
  default     = "Standard_v2"
}

variable "app_gateway_capacity" {
  description = "Application Gateway instance capacity"
  type        = number
  default     = 2
}