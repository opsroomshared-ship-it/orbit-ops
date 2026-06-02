output "hub_resource_group_name" {
  value = module.hub_rg.resource_group_name
}

output "spoke_resource_group_name" {
  value = module.spoke_rg.resource_group_name
}

output "hub_vnet_id" {
  value = module.hub_vnet.vnet_id
}

output "spoke_vnet_id" {
  value = module.spoke_vnet.vnet_id
}

output "hub_vnet_name" {
  value = module.hub_vnet.vnet_name
}

output "spoke_vnet_name" {
  value = module.spoke_vnet.vnet_name
}

output "firewall_id" {
  value = module.azure_firewall.firewall_id
}

output "spoke_subnet_id" {
  value = module.spoke_subnet.subnet_id
}

output "azure_firewall_private_ip" {
  value = module.azure_firewall.firewall_private_ip
}

output "spoke_route_table_id" {
  value = module.spoke_route_table.route_table_id
}