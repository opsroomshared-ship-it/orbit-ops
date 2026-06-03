variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "private_cluster_enabled" {
  type    = bool
  default = true
}

variable "oidc_issuer_enabled" {
  type    = bool
  default = true
}

variable "workload_identity_enabled" {
  type    = bool
  default = true
}

variable "default_node_pool_name" {
  type    = string
  default = "system"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

variable "vnet_subnet_id" {
  type = string
}

variable "user_assigned_identity_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "network_plugin" {
  type    = string
  default = "azure"
}

variable "network_plugin_mode" {
  type    = string
  default = "overlay"
}

variable "network_policy" {
  type    = string
  default = "azure"
}

variable "service_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "dns_service_ip" {
  type    = string
  default = "10.2.0.10"
}

variable "outbound_type" {
  type    = string
  default = "userDefinedRouting"
}

variable "enable_agic" {
  type    = bool
  default = false
}

variable "application_gateway_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}