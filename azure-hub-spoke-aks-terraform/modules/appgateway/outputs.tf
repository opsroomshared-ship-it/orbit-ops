output "application_gateway_id" {
  description = "Application Gateway resource ID."
  value       = azurerm_application_gateway.this.id
}

output "application_gateway_name" {
  description = "Application Gateway name."
  value       = azurerm_application_gateway.this.name
}

output "application_gateway_public_ip" {
  description = "Public IP resource ID for the Application Gateway."
  value       = azurerm_public_ip.appgw_ip.id
}
