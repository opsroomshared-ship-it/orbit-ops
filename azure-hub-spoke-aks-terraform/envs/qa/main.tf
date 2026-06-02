module "rg" {
  source   = "../../modules/resource-group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "hub_vnet" {
  source              = "../../modules/vnet"
  name                = "${var.environment}-hub-vnet"
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

module "spoke_vnet" {
  source              = "../../modules/vnet"
  name                = "${var.environment}-spoke-vnet"
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags
}

module "hub_subnet" {
  source               = "../../modules/subnet"
  name                 = "hub-subnet"
  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.hub_vnet.vnet_name
  address_prefixes     = ["10.0.1.0/24"]
}

module "spoke_subnet" {
  source               = "../../modules/subnet"
  name                 = "spoke-subnet"
  resource_group_name  = module.rg.resource_group_name
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
