variable "scope" {
  type        = string
  description = "Scope for the role assignment."
}

variable "role_definition_name" {
  type        = string
  description = "Role definition name."
}

variable "principal_id" {
  type        = string
  description = "Principal ID to assign the role to."
}
