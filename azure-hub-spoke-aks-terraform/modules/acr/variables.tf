variable "name" {
  type        = string
  description = "ACR name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the ACR."
}

variable "location" {
  type        = string
  description = "Azure location for the ACR."
}

variable "sku" {
  type        = string
  description = "ACR SKU."
  default     = "Basic"
}

variable "admin_enabled" {
  type        = bool
  description = "Enable ACR admin account."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for the ACR."
  default     = {}
}
