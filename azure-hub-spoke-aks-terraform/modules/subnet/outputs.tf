output "subnet_id" {
  description = "Subnet ID."
  value       = azurerm_subnet.this.id
}

output "subnet_name" {
  description = "Subnet name."
  value       = azurerm_subnet.this.name
}

