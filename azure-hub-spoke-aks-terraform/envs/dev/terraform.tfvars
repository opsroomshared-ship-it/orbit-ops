environment = "dev"
location    = "Central India"

hub_vnet_address_space   = ["10.0.0.0/16"]
spoke_vnet_address_space = ["10.1.0.0/16"]

hub_subnet_address_prefixes            = ["10.0.1.0/24"]
azure_firewall_subnet_address_prefixes = ["10.0.10.0/24"]
spoke_subnet_address_prefixes          = ["10.1.1.0/24"]

azure_firewall_sku_tier = "Standard"

tags = {
  Environment = "dev"
  Project     = "orbit"
  ManagedBy   = "terraform"
}

