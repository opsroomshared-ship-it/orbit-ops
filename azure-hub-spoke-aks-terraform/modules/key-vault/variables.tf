variable "name" {
  type        = string
  description = "Key Vault name."
}

variable "location" {
  type        = string
  description = "Azure location for the Key Vault."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the Key Vault."
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID for the Key Vault."
}

variable "sku_name" {
  type        = string
  description = "Key Vault SKU name."
  default     = "standard"
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection."
  default     = false
}

variable "soft_delete_enabled" {
  type        = bool
  description = "Enable soft delete."
  default     = true
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Enable VM deployment access."
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Enable disk encryption access."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Key Vault."
  default     = {}
}
