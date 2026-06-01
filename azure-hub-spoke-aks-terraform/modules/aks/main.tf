resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  default_node_pool {
    name       = var.node_pool_name
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  dns_prefix = var.dns_prefix

  network_profile {
    network_plugin = var.network_plugin
  }

  identity {
    type = var.identity_type
  }

  tags = var.tags
}
