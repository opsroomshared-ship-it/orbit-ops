resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                = "${var.name}-policy"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_tier
  tags                = var.tags
  
  dns {
    proxy_enabled = true
  }

}

resource "azurerm_firewall" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.this.id
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "${var.name}-rcg"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 100

  application_rule_collection {
    name     = "allow-dev-web"
    priority = 100
    action   = "Allow"

    rule {
      name = "allow-websites"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_addresses = var.source_addresses

      destination_fqdns = [
        "*.microsoft.com",
        "*.azure.com",
        "*.ubuntu.com",
        "*.docker.io",
        "*.github.com",
        "github.com",
        "login.microsoftonline.com",
        "management.azure.com"
      ]
    }
  }

  network_rule_collection {
    name     = "allow-dev-network"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "allow-dns"
      protocols             = ["UDP", "TCP"]
      source_addresses      = var.source_addresses
      destination_addresses = ["8.8.8.8", "1.1.1.1"]
      destination_ports     = ["53"]
    }

    rule {
      name                  = "allow-https"
      protocols             = ["TCP"]
      source_addresses      = var.source_addresses
      destination_addresses = ["*"]
      destination_ports     = ["443"]
    }
  }
}

