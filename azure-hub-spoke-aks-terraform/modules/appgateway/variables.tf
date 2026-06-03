variable "name" {
  type        = string
  description = "Application Gateway name."
}

variable "location" {
  type        = string
  description = "Azure location for the Application Gateway."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the Application Gateway."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the Application Gateway."
}

variable "sku_name" {
  type        = string
  description = "Application Gateway SKU name."
  default     = "Standard_V2"
}

variable "sku_tier" {
  type        = string
  description = "Application Gateway SKU tier."
  default     = "Standard_V2"
}

variable "capacity" {
  type        = number
  description = "Instance capacity for the gateway."
  default     = 2
}

variable "frontend_port" {
  type        = number
  description = "Frontend port for the Application Gateway."
  default     = 80
}

variable "tags" {
  type        = map(string)
  description = "Tags for the Application Gateway."
  default     = {}
}
variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "Standard_v2"
}

variable "sku_tier" {
  type    = string
  default = "Standard_v2"
}

variable "capacity" {
  type    = number
  default = 2
}
