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
