output "identity_id" {
  description = "User-assigned identity ID."
  value       = azurerm_user_assigned_identity.this.id
}

output "identity_principal_id" {
  description = "Principal ID for the identity."
  value       = azurerm_user_assigned_identity.this.principal_id
}
