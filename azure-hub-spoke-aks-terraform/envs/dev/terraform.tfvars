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

key_vault_private_dns_zone_name = "privatelink.vaultcore.azure.net"
acr_private_dns_zone_name       = "privatelink.azurecr.io"

private_cluster_enabled = true
aks_node_count          = 2
aks_vm_size             = "Standard_D2s_v5"

aks_service_cidr   = "10.2.0.0/16"
aks_dns_service_ip = "10.2.0.10"

enable_agic = true


app_gateway_subnet_address_prefixes = ["10.0.20.0/24"]

app_gateway_sku_name = "Standard_v2"
app_gateway_sku_tier = "Standard_v2"
app_gateway_capacity = 2