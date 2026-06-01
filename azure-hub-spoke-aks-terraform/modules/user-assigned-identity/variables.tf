variable "name" {
  type        = string
  description = "User-assigned identity name."
}

variable "location" {
  type        = string
  description = "Azure location for the identity."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the identity."
}

variable "tags" {
  type        = map(string)
  description = "Tags for the identity."
  default     = {}
}
