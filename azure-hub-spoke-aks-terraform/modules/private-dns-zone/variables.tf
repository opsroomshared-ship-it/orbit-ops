variable "name" {
  type        = string
  description = "Private DNS zone name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the private DNS zone."
}

variable "tags" {
  type        = map(string)
  description = "Tags for the private DNS zone."
  default     = {}
}
