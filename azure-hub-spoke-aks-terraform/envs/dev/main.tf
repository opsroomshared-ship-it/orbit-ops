locals {
  base_name            = "${var.environment}-azure-hub-spoke"
  hub_resource_group   = "${local.base_name}-hub-rg"
  spoke_resource_group = "${local.base_name}-spoke-rg"
  hub_vnet_name        = "${local.base_name}-hub-vnet"
  spoke_vnet_name      = "${local.base_name}-spoke-vnet"
  hub_subnet_name      = "${local.base_name}-hub-subnet"
  spoke_subnet_name    = "${local.base_name}-spoke-subnet"
}

module "hub_rg" {
  source    = "../../modules/resource-group"
  name      = local.hub_resource_group
  location  = var.location
  tags      = var.tags
}

module "spoke_rg" {
  source    = "../../modules/resource-group"
  name      = local.spoke_resource_group
  location  = var.location
  tags      = var.tags
}



module "hub_vnet" {
  source              = "../../modules/vnet"
  name                = local.hub_vnet_name
  location            = var.location
  resource_group_name = module.hub_rg.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

module "spoke_vnet" {
  source              = "../../modules/vnet"
  name                = local.spoke_vnet_name
  location            = var.location
  resource_group_name = module.spoke_rg.resource_group_name
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags
}

module "hub_subnet" {
  source               = "../../modules/subnet"
  name                 = local.hub_subnet_name
  resource_group_name  = module.hub_rg.resource_group_name
  virtual_network_name = module.hub_vnet.vnet_name
  address_prefixes     = ["10.0.1.0/24"]
}

module "spoke_subnet" {
  source               = "../../modules/subnet"
  name                 = local.spoke_subnet_name
  resource_group_name  = module.spoke_rg.resource_group_name
  virtual_network_name = module.spoke_vnet.vnet_name
  address_prefixes     = ["10.1.1.0/24"]
}

# Add other modules below as needed:
# - vnet-peering
# - route-table
# - firewall
# - log-analytics
# - acr
# - key-vault
# - private-dns-zone
# - private-endpoint
# - user-assigned-identity
# - role-assignment
# - aks
# - appgateway
# - agic-add-on
