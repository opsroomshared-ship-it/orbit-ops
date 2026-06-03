locals {
  base_name = "${var.environment}-orbit"

  hub_resource_group   = "${local.base_name}-hub-rg"
  spoke_resource_group = "${local.base_name}-spoke-rg"

  hub_vnet_name   = "${local.base_name}-hub-vnet"
  spoke_vnet_name = "${local.base_name}-spoke-vnet"

  hub_subnet_name   = "${local.base_name}-hub-subnet"
  spoke_subnet_name = "${local.base_name}-spoke-subnet"

  spoke_route_table_name = "${local.base_name}-spoke-rt"
  app_gateway_subnet_name = "AppGatewaySubnet"
  app_gateway_name        = "${local.base_name}-appgw"
}

module "hub_rg" {
  source   = "../../modules/resource-group"
  name     = local.hub_resource_group
  location = var.location
  tags     = var.tags
}

module "spoke_rg" {
  source   = "../../modules/resource-group"
  name     = local.spoke_resource_group
  location = var.location
  tags     = var.tags
}

module "hub_vnet" {
  source              = "../../modules/vnet"
  name                = local.hub_vnet_name
  location            = var.location
  resource_group_name = module.hub_rg.resource_group_name
  address_space       = var.hub_vnet_address_space
  tags                = var.tags
}

module "spoke_vnet" {
  source              = "../../modules/vnet"
  name                = local.spoke_vnet_name
  location            = var.location
  resource_group_name = module.spoke_rg.resource_group_name
  address_space       = var.spoke_vnet_address_space
  tags                = var.tags
}

module "hub_to_spoke_peering" {
  source = "../../modules/vnet-peering"

  name                      = "peer-${local.hub_vnet_name}-to-${local.spoke_vnet_name}"
  resource_group_name       = module.hub_rg.resource_group_name
  virtual_network_name      = module.hub_vnet.vnet_name
  remote_virtual_network_id = module.spoke_vnet.vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit = true
}

module "spoke_to_hub_peering" {
  source = "../../modules/vnet-peering"

  name                      = "peer-${local.spoke_vnet_name}-to-${local.hub_vnet_name}"
  resource_group_name       = module.spoke_rg.resource_group_name
  virtual_network_name      = module.spoke_vnet.vnet_name
  remote_virtual_network_id = module.hub_vnet.vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways = true
}


module "hub_subnet" {
  source               = "../../modules/subnet"
  name                 = local.hub_subnet_name
  resource_group_name  = module.hub_rg.resource_group_name
  virtual_network_name = module.hub_vnet.vnet_name
  address_prefixes     = var.hub_subnet_address_prefixes
}

module "spoke_subnet" {
  source               = "../../modules/subnet"
  name                 = local.spoke_subnet_name
  resource_group_name  = module.spoke_rg.resource_group_name
  virtual_network_name = module.spoke_vnet.vnet_name
  address_prefixes     = var.spoke_subnet_address_prefixes
}

module "azure_firewall_subnet" {
  source               = "../../modules/subnet"
  name                 = "AzureFirewallSubnet"
  resource_group_name  = module.hub_rg.resource_group_name
  virtual_network_name = module.hub_vnet.vnet_name
  address_prefixes     = var.azure_firewall_subnet_address_prefixes
}

module "azure_firewall" {
  source = "../../modules/firewall"

  name                = "${local.base_name}-azfw"
  location            = var.location
  resource_group_name = module.hub_rg.resource_group_name
  firewall_subnet_id  = module.azure_firewall_subnet.subnet_id
  sku_tier            = var.azure_firewall_sku_tier
  source_addresses    = var.spoke_vnet_address_space
  tags                = var.tags
}

module "spoke_route_table" {
  source = "../../modules/route-table"

  name                = local.spoke_route_table_name
  location            = var.location
  resource_group_name = module.spoke_rg.resource_group_name
  tags                = var.tags

  routes = [
    {
      name                   = "default-route-to-firewall"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.azure_firewall.firewall_private_ip
    }
  ]
}

resource "azurerm_subnet_route_table_association" "spoke_subnet_rt" {
  subnet_id      = module.spoke_subnet.subnet_id
  route_table_id = module.spoke_route_table.route_table_id
}

module "log_analytics" {
  source = "../../modules/log-analytics"

  name                = "${local.base_name}-law"
  location            = var.location
  resource_group_name = module.hub_rg.resource_group_name
  retention_in_days   = 30
  tags                = var.tags
}


module "azure_firewall_diagnostics" {
  source = "../../modules/diagnostic-settings"

  name                       = "${local.base_name}-azfw-diag"
  target_resource_id         = module.azure_firewall.firewall_id
  log_analytics_workspace_id = module.log_analytics.workspace_id

  enabled_logs = [
    "AzureFirewallApplicationRule",
    "AzureFirewallNetworkRule",
    "AzureFirewallDnsProxy"
  ]

  enabled_metrics = [
    "AllMetrics"
  ]
}

module "acr" {
  source = "../../modules/acr"

  name                = replace("${local.base_name}acr", "-", "")
  location            = var.location
  resource_group_name = module.spoke_rg.resource_group_name
  sku                 = "Premium"
  admin_enabled       = false
  tags                = var.tags
}

module "aks_identity" {
  source = "../../modules/user-assigned-identity"

  name                = "${local.base_name}-aks-mi"
  location            = var.location
  resource_group_name = module.spoke_rg.resource_group_name
  tags                = var.tags
}

module "acr_pull_role" {
  source = "../../modules/role-assignment"

  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_identity.principal_id
}

data "azurerm_client_config" "current" {}

module "key_vault" {
  source = "../../modules/key-vault"

  name                = replace("${local.base_name}-kv", "-", "")
  location            = var.location
  resource_group_name = module.spoke_rg.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  public_network_access_enabled = true

  tags = var.tags
}

module "kv_secrets_user_role" {
  source = "../../modules/role-assignment"

  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.aks_identity.principal_id
}

module "key_vault_private_dns_zone" {
  source = "../../modules/private-dns-zone"

  name                = var.key_vault_private_dns_zone_name
  resource_group_name = module.spoke_rg.resource_group_name
  virtual_network_id  = module.spoke_vnet.vnet_id
  tags                = var.tags
}

module "acr_private_dns_zone" {
  source = "../../modules/private-dns-zone"

  name                = var.acr_private_dns_zone_name
  resource_group_name = module.spoke_rg.resource_group_name
  virtual_network_id  = module.spoke_vnet.vnet_id
  tags                = var.tags
}

module "key_vault_private_endpoint" {
  source = "../../modules/private-endpoint"

  name                           = "${local.base_name}-kv-pe"
  location                       = var.location
  resource_group_name            = module.spoke_rg.resource_group_name
  subnet_id                      = module.spoke_subnet.subnet_id
  private_connection_resource_id = module.key_vault.key_vault_id
  subresource_names              = ["vault"]
  private_dns_zone_ids           = [module.key_vault_private_dns_zone.private_dns_zone_id]
  tags                           = var.tags
}

module "acr_private_endpoint" {
  source = "../../modules/private-endpoint"

  name                           = "${local.base_name}-acr-pe"
  location                       = var.location
  resource_group_name            = module.spoke_rg.resource_group_name
  subnet_id                      = module.spoke_subnet.subnet_id
  private_connection_resource_id = module.acr.acr_id
  subresource_names              = ["registry"]
  private_dns_zone_ids           = [module.acr_private_dns_zone.private_dns_zone_id]
  tags                           = var.tags
}

module "aks" {
  source = "../../modules/aks"

  name                = "${local.base_name}-aks"
  location            = var.location
  resource_group_name = module.spoke_rg.resource_group_name
  dns_prefix          = "${local.base_name}-aks"

  private_cluster_enabled = var.private_cluster_enabled

  node_count = var.aks_node_count
  vm_size    = var.aks_vm_size

  vnet_subnet_id             = module.spoke_subnet.subnet_id
  user_assigned_identity_id  = module.aks_identity.identity_id
  log_analytics_workspace_id = module.log_analytics.workspace_id

  service_cidr   = var.aks_service_cidr
  dns_service_ip = var.aks_dns_service_ip

  enable_agic            = var.enable_agic
  application_gateway_id = module.app_gateway.application_gateway_id

  tags = var.tags
}

module "aks_kubelet_acr_pull_role" {
  source = "../../modules/role-assignment"

  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}

module "agic_appgw_contributor_role" {
  source = "../../modules/role-assignment"

  scope                = module.app_gateway.application_gateway_id
  role_definition_name = "Contributor"
  principal_id         = module.aks.agic_identity_object_id
}

module "app_gateway" {
  source = "../../modules/app-gateway"

  name                = local.app_gateway_name
  location            = var.location
  resource_group_name = module.hub_rg.resource_group_name
  subnet_id           = module.app_gateway_subnet.subnet_id

  sku_name = var.app_gateway_sku_name
  sku_tier = var.app_gateway_sku_tier
  capacity = var.app_gateway_capacity

  tags = var.tags
}



# - appgateway
# - agic-add-on
