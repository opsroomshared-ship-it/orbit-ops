variable "name" {
  type        = string
  description = "Private endpoint name."
}

variable "location" {
  type        = string
  description = "Azure location for the private endpoint."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the private endpoint."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the private endpoint."
}

variable "connection_name" {
  type        = string
  description = "Service connection name."
}

variable "private_connection_resource_id" {
  type        = string
  description = "Resource ID of the service to connect privately."
}

variable "subresource_names" {
  type        = list(string)
  description = "Subresource names for the connection."
  default     = []
}

variable "is_manual_connection" {
  type        = bool
  description = "Whether connection is manual."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags for the private endpoint."
  default     = {}
}
