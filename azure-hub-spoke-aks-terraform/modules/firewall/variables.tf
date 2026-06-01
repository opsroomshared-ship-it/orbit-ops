variable "name" {
  type        = string
  description = "Firewall name."
}

variable "location" {
  type        = string
  description = "Azure location for the firewall."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the firewall."
}

variable "sku_name" {
  type        = string
  description = "Firewall SKU name."
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  type        = string
  description = "Firewall SKU tier."
  default     = "Premium"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the firewall."
}

variable "public_ip_address_id" {
  type        = string
  description = "Public IP address ID for the firewall."
}

variable "tags" {
  type        = map(string)
  description = "Tags for the firewall."
  default     = {}
}
