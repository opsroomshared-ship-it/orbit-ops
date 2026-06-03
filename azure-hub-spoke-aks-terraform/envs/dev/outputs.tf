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

output "acr_name" {
  value = module.acr.acr_name
}

output "acr_login_server" {
  value = module.acr.acr_login_server
}

output "aks_identity_client_id" {
  value = module.aks_identity.client_id
}

output "aks_identity_principal_id" {
  value = module.aks_identity.principal_id
}

output "acr_pull_role_assignment_id" {
  value = module.acr_pull_role.role_assignment_id
}

output "key_vault_name" {
  value = module.key_vault.key_vault_name
}

output "key_vault_id" {
  value = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  value = module.key_vault.key_vault_uri
}


output "key_vault_private_dns_zone_id" {
  value = module.key_vault_private_dns_zone.private_dns_zone_id
}

output "acr_private_dns_zone_id" {
  value = module.acr_private_dns_zone.private_dns_zone_id
}

output "key_vault_private_endpoint_ip" {
  value = module.key_vault_private_endpoint.private_endpoint_private_ip
}

output "acr_private_endpoint_ip" {
  value = module.acr_private_endpoint.private_endpoint_private_ip
}

output "aks_name" {
  value = module.aks.aks_name
}

output "aks_id" {
  value = module.aks.aks_id
}

output "aks_oidc_issuer_url" {
  value = module.aks.oidc_issuer_url
}

output "aks_kubelet_identity_object_id" {
  value = module.aks.kubelet_identity_object_id
}

output "agic_identity_object_id" {
  value = module.aks.agic_identity_object_id
}

output "app_gateway_id" {
  value = module.app_gateway.application_gateway_id
}

output "app_gateway_name" {
  value = module.app_gateway.application_gateway_name
}

output "app_gateway_public_ip" {
  value = module.app_gateway.application_gateway_public_ip
}