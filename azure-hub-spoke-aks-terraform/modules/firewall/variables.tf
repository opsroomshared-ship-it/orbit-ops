variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "firewall_subnet_id" {
  type = string
}

variable "sku_tier" {
  type    = string
  default = "Standard"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "source_addresses" {
  description = "Source address ranges allowed through firewall."
  type        = list(string)
}