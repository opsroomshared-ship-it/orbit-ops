variable "location" {
  type        = string
  description = "Azure location for this environment."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for this environment."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}
