variable "name" {
  type        = string
  description = "Log Analytics workspace name."
}

variable "location" {
  type        = string
  description = "Azure region for the workspace."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the workspace."
}

variable "sku" {
  type        = string
  description = "Workspace SKU."
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "Retention period in days."
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags for the workspace."
  default     = {}
}
