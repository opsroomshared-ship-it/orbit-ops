variable "name" {
  type        = string
  description = "Virtual network name."
}

variable "location" {
  type        = string
  description = "Azure region for the VNet."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the VNet."
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the VNet."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VNet."
  default     = {}
}
