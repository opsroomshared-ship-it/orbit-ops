variable "name" {
  type        = string
  description = "Extension name."
  default     = "agic"
}

variable "cluster_name" {
  type        = string
  description = "AKS cluster name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the AKS cluster."
}

variable "release_train" {
  type        = string
  description = "Release train for the add-on."
  default     = "Rapid"
}

variable "configuration_settings" {
  type        = map(string)
  description = "Configuration settings for the add-on."
  default     = {}
}
