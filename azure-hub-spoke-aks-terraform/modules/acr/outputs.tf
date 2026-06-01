output "acr_id" {
  description = "ACR resource ID."
  value       = azurerm_container_registry.this.id
}

output "acr_login_server" {
  description = "ACR login server."
  value       = azurerm_container_registry.this.login_server
}
