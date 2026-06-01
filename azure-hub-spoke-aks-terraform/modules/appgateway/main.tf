resource "azurerm_public_ip" "appgw_ip" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = "appgw_ip_config"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "frontendPort"
    port = var.frontend_port
  }

  frontend_ip_configuration {
    name                 = "appgw_frontend_ip"
    public_ip_address_id = azurerm_public_ip.appgw_ip.id
  }

  tags = var.tags
}
