output "agic_extension_id" {
  description = "Kubernetes cluster extension ID for AGIC."
  value       = azurerm_kubernetes_cluster_extension.agic.id
}
