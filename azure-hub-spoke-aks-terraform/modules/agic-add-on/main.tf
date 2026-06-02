resource "azurerm_kubernetes_cluster_extension" "agic" {
  name                       = "agic"
  cluster_name               = var.cluster_name
  resource_group_name        = var.resource_group_name
  extension_type             = "Microsoft.Azure.ActiveDirectory"
  auto_upgrade_minor_version = true
  release_train              = var.release_train
  configuration_settings     = var.configuration_settings
}
