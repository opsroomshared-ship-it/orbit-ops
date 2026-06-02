output "peering_id" {
  description = "Virtual network peering ID."
  value       = azurerm_virtual_network_peering.this.id
}
output "name" {
  value = azurerm_virtual_network_peering.this.name
}