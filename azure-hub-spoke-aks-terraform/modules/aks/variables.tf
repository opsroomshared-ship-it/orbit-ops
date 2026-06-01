variable "name" {
  type        = string
  description = "AKS cluster name."
}

variable "location" {
  type        = string
  description = "Azure location for the AKS cluster."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the AKS cluster."
}

variable "node_pool_name" {
  type        = string
  description = "Default node pool name."
  default     = "agentpool"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the default pool."
  default     = 3
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes."
  default     = "Standard_DS2_v2"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster."
}

variable "network_plugin" {
  type        = string
  description = "Network plugin for AKS."
  default     = "azure"
}

variable "identity_type" {
  type        = string
  description = "Identity type for AKS."
  default     = "SystemAssigned"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to AKS."
  default     = {}
}
