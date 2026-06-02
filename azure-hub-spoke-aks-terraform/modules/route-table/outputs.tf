output "route_table_id" {
  description = "Route Table ID."
  value       = azurerm_route_table.this.id
}

output "route_table_name" {
  description = "Route Table name."
  value       = azurerm_route_table.this.name
}