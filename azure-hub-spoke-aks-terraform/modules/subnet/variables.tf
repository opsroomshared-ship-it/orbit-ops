variable "name" {
  type        = string
  description = "Subnet name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the subnet."
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual network name for the subnet."
}

variable "address_prefixes" {
  type        = list(string)
  description = "Subnet address prefixes."
}

variable "service_endpoints" {
  type        = list(string)
  description = "Service endpoints for the subnet."
  default     = []
}
