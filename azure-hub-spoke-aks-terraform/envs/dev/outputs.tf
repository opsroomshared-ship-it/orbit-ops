output "resource_group_name" {
  description = "The resource group name created for the environment."
  value       = module.rg.resource_group_name
}

output "hub_vnet_id" {
  description = "The hub virtual network ID."
  value       = module.hub_vnet.vnet_id
}

output "spoke_vnet_id" {
  description = "The spoke virtual network ID."
  value       = module.spoke_vnet.vnet_id
}
