output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_customer_id" {
  description = "Log Analytics workspace customer ID."
  value       = azurerm_log_analytics_workspace.this.customer_id
}
