variable "name" {
  type        = string
  description = "Peering name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the peering."
}

variable "virtual_network_name" {
  type        = string
  description = "Local virtual network name."
}

variable "remote_virtual_network_id" {
  type        = string
  description = "Remote virtual network resource ID."
}

variable "allow_forwarded_traffic" {
  type        = bool
  description = "Allow forwarded traffic through the peering."
  default     = false
}

variable "allow_gateway_transit" {
  type        = bool
  description = "Allow gateway transit."
  default     = false
}

variable "use_remote_gateways" {
  type        = bool
  description = "Use remote gateways."
  default     = false
}
