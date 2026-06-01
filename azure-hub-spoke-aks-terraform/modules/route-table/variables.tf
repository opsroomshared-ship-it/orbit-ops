variable "name" {
  type        = string
  description = "Route table name."
}

variable "location" {
  type        = string
  description = "Azure region for the route table."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the route table."
}

variable "tags" {
  type        = map(string)
  description = "Tags for the route table."
  default     = {}
}

variable "routes" {
  type = list(object({
    name                = string
    address_prefix      = string
    next_hop_type       = string
    next_hop_in_ip_address = optional(string)
  }))
  description = "List of routes to create on the route table."
  default     = []
}
