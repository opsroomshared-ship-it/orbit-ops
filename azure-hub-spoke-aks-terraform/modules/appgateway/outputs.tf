output "appgateway_id" {
  description = "Application Gateway resource ID."
  value       = azurerm_application_gateway.this.id
}

output "appgateway_public_ip_id" {
  description = "Public IP resource ID for the Application Gateway."
  value       = azurerm_public_ip.appgw_ip.id
}
