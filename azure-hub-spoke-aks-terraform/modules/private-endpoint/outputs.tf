output "private_endpoint_id" {
  value = azurerm_private_endpoint.this.id
}

output "private_endpoint_name" {
  value = azurerm_private_endpoint.this.name
}

output "private_endpoint_private_ip" {
  value = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}