# Azure Hub-Spoke AKS Terraform Landing Zone

## 1. Project Overview

### What this Terraform project builds
This repository provisions an Azure landing zone using a hub-spoke network topology that includes:
- Azure resource groups for hub and spoke workloads
- Azure Virtual Networks (VNet) with subnet segmentation
- Azure Firewall deployed in the hub for centralized traffic control
- Azure Application Gateway in the hub as the north-south ingress layer
- Azure Kubernetes Service (AKS) in the spoke as the application platform
- Azure Container Registry (ACR) for container image storage
- Azure Key Vault for secret and certificate management
- Managed identities for least-privilege service access
- Private endpoints and private DNS for secure service connectivity
- Log Analytics for centralized observability and diagnostics

### Business purpose
This project is designed to deliver a production-grade cloud platform blueprint for enterprise applications that require:
- network isolation and segmentation
- centralized security and inspection
- secure container deployment and delivery
- private access to platform services
- observability and compliance readiness

### Architecture goals
- Enforce strong perimeter control with Azure Firewall
- Reduce attack surface with private networking and private endpoints
- Centralize egress and ingress through monitored hub services
- Implement least-privilege access using managed identities and RBAC
- Separate platform infrastructure from workload infrastructure with hub/spoke design
- Make the platform reusable across dev/test/prod environments

### Why Hub-Spoke architecture is used
A hub-spoke model is used because it:
- centralizes shared services and security controls in a hub VNet
- isolates workload VNets in spokes
- reduces network complexity by centralizing routing and firewalling
- allows multiple spoke tenants or applications to share hub services safely

### Why Azure Firewall is used
Azure Firewall is used because it:
- provides centralized outbound and inbound traffic filtering
- supports application and network rules
- can enforce DNS proxy for private and secure name resolution
- integrates with route tables and hub-spoke transit topologies

### Why Application Gateway is used
Application Gateway is used because it:
- provides HTTP/HTTPS load balancing at the application layer
- supports web application routing and SSL termination
- enables future Web Application Firewall (WAF) capabilities
- integrates natively with AKS via AGIC for ingress management

### Why AKS is used
AKS is used because it:
- simplifies Kubernetes operations in Azure
- provides Azure-native cluster management
- supports private clusters, managed identities, and workload identity
- integrates with ACR, Key Vault, Log Analytics and networking

### Why ACR is used
ACR is used because it:
- stores container images close to the Azure Kubernetes deployment
- supports secure image pull with Azure RBAC and private endpoints
- integrates with AKS and Azure Active Directory
- enables enterprise container management and image lifecycle controls

### Why Key Vault is used
Key Vault is used because it:
- secures secrets, certificates, and keys in a managed service
- allows access control using Azure RBAC and managed identities
- supports private endpoint access for service isolation
- reduces the need to store secrets in code or containers

### Why Managed Identities are used
Managed identities are used because they:
- provide credentialless access to Azure resources
- simplify authentication for AKS, ACR, and Key Vault
- support least-privilege security patterns
- remove static service principal secrets from the infrastructure

### Why Private Endpoints are used
Private endpoints are used because they:
- enable private, VNet-local access to platform services
- keep traffic off the public internet for ACR and Key Vault
- allow secure DNS resolution through private DNS zones
- work together with hub-spoke routing to preserve isolation

### Why Log Analytics is used
Log Analytics is used because it:
- centralizes diagnostic logs and metrics
- collects AKS cluster telemetry and Azure Firewall diagnostics
- supports alerting, queries, and operational troubleshooting
- provides an audit trail for security and compliance

### Design principles
- Security-first: least privilege, private networking, and centralized firewalling
- Modular: reusable modules for common infrastructure constructs
- Observable: telemetry and diagnostics enabled by default
- Scalable: hub-spoke pattern supports growth and multi-environment use
- Declarative: Terraform code expresses desired state cleanly
- Separation of concerns: infrastructure, networking, compute, and security separated

---

## 2. Repository Structure

This repository is organized into a single environment layer and reusable modules.

```
azure-hub-spoke-aks-terraform/
  envs/
    dev/
      backend.tf
      main.tf
      outputs.tf
      provider.tf
      terraform.tfvars
      variables.tf
  modules/
    acr/
      main.tf
      outputs.tf
      variables.tf
    agic-add-on/
      main.tf
      variables.tf
    aks/
      main.tf
      outputs.tf
      variables.tf
    appgateway/
      main.tf
      outputs.tf
      variables.tf
    diagnostic-settings/
      main.tf
      variables.tf
    firewall/
      main.tf
      outputs.tf
      variables.tf
    key-vault/
      main.tf
      variables.tf
      outputs.tf
    log-analytics/
      main.tf
      outputs.tf
      variables.tf
    private-dns-zone/
      main.tf
      outputs.tf
      variables.tf
    private-endpoint/
      main.tf
      outputs.tf
      variables.tf
    resource-group/
      main.tf
      outputs.tf
      variables.tf
    role-assignment/
      main.tf
      variables.tf
    route-table/
      main.tf
      variables.tf
    subnet/
      main.tf
      outputs.tf
      variables.tf
    user-assigned-identity/
      main.tf
      outputs.tf
      variables.tf
    vnet/
      main.tf
      outputs.tf
      variables.tf
    vnet-peering/
      main.tf
      variables.tf
```

### Folder purpose
- `envs/dev/`: Environment-specific configuration for the `dev` deployment.
- `modules/`: Reusable Terraform modules that implement individual Azure services and platform patterns.
- `modules/acr/`: Builds Azure Container Registry.
- `modules/agic-add-on/`: Contains an AGIC extension module; not currently referenced by `envs/dev/main.tf`.
- `modules/aks/`: Builds AKS clusters with network, identity, and logging configuration.
- `modules/appgateway/`: Builds Application Gateway with frontend listener and routing.
- `modules/diagnostic-settings/`: Attaches Azure diagnostics to Log Analytics.
- `modules/firewall/`: Builds Azure Firewall, public IP, firewall policy, and rule collections.
- `modules/key-vault/`: Builds Key Vault with RBAC authorization.
- `modules/log-analytics/`: Builds a Log Analytics workspace.
- `modules/private-dns-zone/`: Builds private DNS zones and virtual network links.
- `modules/private-endpoint/`: Builds private endpoints for platform services.
- `modules/resource-group/`: Builds Azure resource groups.
- `modules/role-assignment/`: Creates RBAC role assignments.
- `modules/route-table/`: Builds route tables and UDRs.
- `modules/subnet/`: Builds subnets inside VNets.
- `modules/user-assigned-identity/`: Builds Azure user-assigned managed identities.
- `modules/vnet/`: Builds virtual networks.
- `modules/vnet-peering/`: Builds VNet peerings between hub and spoke.

---

## 3. Environment Layer Explanation (`envs/dev`)

### `backend.tf`
- Purpose: Defines the Terraform state backend for the environment.
- Remote state: In this repo, the backend is currently configured as `local`, storing state in `terraform.tfstate` inside `envs/dev`.
- State locking: The local backend does not support locking. For team or enterprise use, a remote backend such as `azurerm`, `terraform cloud`, or `hashicorp` should be used.
- Why backend is required: Terraform stores state to track resource mappings and dependencies. A backend is required to persist that state across runs and to enable safe collaboration.

> Note: For enterprise deployments, replace the local backend with an Azure Storage backend or Terraform Cloud backend to enable remote state storage, locking, and state versioning.

### `provider.tf`
- AzureRM provider: Configures the `azurerm` provider with default feature flags. It enables Terraform to manage Azure resources.
- AzureAD provider: Not present in this environment. If the project were to manage Azure Active Directory resources directly, the `azuread` provider would be added.
- Authentication methods: Provider configuration is empty, meaning authentication is delegated to the environment. Common options are Azure CLI login, environment variables, Managed Identity, or a service principal.

### `variables.tf`

| Variable | Type | Purpose | Example value |
|---|---|---|---|
| `environment` | string | Deployment environment identifier. | `dev` |
| `location` | string | Azure region for all resources. | `Central India` |
| `tags` | map(string) | Common tags to apply to resources. | `{ Environment = "dev", Project = "orbit" }` |
| `hub_vnet_address_space` | list(string) | Address space for the hub VNet. | `["10.0.0.0/16"]` |
| `spoke_vnet_address_space` | list(string) | Address space for the spoke VNet. | `["10.1.0.0/16"]` |
| `hub_subnet_address_prefixes` | list(string) | CIDR for the shared hub subnet. | `["10.0.1.0/24"]` |
| `spoke_subnet_address_prefixes` | list(string) | CIDR for the spoke workload subnet. | `["10.1.1.0/24"]` |
| `azure_firewall_subnet_address_prefixes` | list(string) | CIDR for the Azure Firewall subnet. | `["10.0.10.0/24"]` |
| `azure_firewall_sku_tier` | string | Firewall SKU tier. | `Standard` |
| `key_vault_private_dns_zone_name` | string | Private DNS zone for Key Vault private link. | `privatelink.vaultcore.azure.net` |
| `acr_private_dns_zone_name` | string | Private DNS zone for ACR private link. | `privatelink.azurecr.io` |
| `private_cluster_enabled` | bool | Enable private AKS cluster. | `true` |
| `aks_node_count` | number | Default node count for AKS. | `2` |
| `aks_vm_size` | string | VM size for AKS nodes. | `Standard_D2s_v5` |
| `aks_service_cidr` | string | Service CIDR range for AKS cluster services. | `10.2.0.0/16` |
| `aks_dns_service_ip` | string | DNS service IP inside AKS service CIDR. | `10.2.0.10` |
| `enable_agic` | bool | Enable Application Gateway integration with AKS. | `true` |
| `app_gateway_subnet_address_prefixes` | list(string) | CIDR for the App Gateway subnet. | `["10.0.20.0/24"]` |
| `app_gateway_sku_name` | string | Application Gateway SKU name. | `Standard_v2` |
| `app_gateway_sku_tier` | string | Application Gateway SKU tier. | `Standard_v2` |
| `app_gateway_capacity` | number | Application Gateway instance capacity. | `2` |

### `terraform.tfvars`

| Setting | Meaning | Impact | Example |
|---|---|---|---|
| `environment` | The target environment for the deployment. | Controls naming and scope. | `dev` |
| `location` | The Azure region for resource creation. | Affects compliance, latency, and pricing. | `Central India` |
| `hub_vnet_address_space` | Hub VNet CIDR blocks. | Defines hub network range. | `["10.0.0.0/16"]` |
| `spoke_vnet_address_space` | Spoke VNet CIDR blocks. | Defines spoke network range. | `["10.1.0.0/16"]` |
| `hub_subnet_address_prefixes` | Hub shared subnet CIDR. | Used for hub resources like DNS or shared services. | `["10.0.1.0/24"]` |
| `azure_firewall_subnet_address_prefixes` | Firewall subnet CIDR. | Reserves space for Azure Firewall. | `["10.0.10.0/24"]` |
| `spoke_subnet_address_prefixes` | Spoke workload subnet CIDR. | Used for AKS and private endpoints. | `["10.1.1.0/24"]` |
| `azure_firewall_sku_tier` | Firewall SKU tier. | Affects cost and throughput. | `Standard` |
| `tags` | Resource tags. | Enables governance, billing, and filtering. | `{ Environment = "dev", Project = "orbit" }` |
| `key_vault_private_dns_zone_name` | Private DNS zone for Key Vault. | Enables private endpoint DNS resolution. | `privatelink.vaultcore.azure.net` |
| `acr_private_dns_zone_name` | Private DNS zone for ACR. | Enables private endpoint DNS resolution. | `privatelink.azurecr.io` |
| `private_cluster_enabled` | AKS private cluster toggle. | Controls API server accessibility. | `true` |
| `aks_node_count` | AKS default worker node count. | Affects cluster capacity and cost. | `2` |
| `aks_vm_size` | AKS node size. | Affects performance and pricing. | `Standard_D2s_v5` |
| `aks_service_cidr` | Service network CIDR. | Reserved for cluster internal services. | `10.2.0.0/16` |
| `aks_dns_service_ip` | Cluster DNS service IP. | Required for pod DNS resolution. | `10.2.0.10` |
| `enable_agic` | Enable Application Gateway integration. | Controls ingress integration behavior. | `true` |
| `app_gateway_subnet_address_prefixes` | App Gateway subnet CIDR. | Reserves application gateway network space. | `["10.0.20.0/24"]` |
| `app_gateway_sku_name` | App Gateway SKU. | Affects throughput and feature set. | `Standard_v2` |
| `app_gateway_sku_tier` | App Gateway SKU tier. | Must match SKU. | `Standard_v2` |
| `app_gateway_capacity` | App Gateway capacity. | Controls scale units. | `2` |

### `outputs.tf`
Each output exposes an important infrastructure artifact for integrations, references, and post-deployment validation.

| Output | Why it exists | Likely consumer |
|---|---|---|
| `hub_resource_group_name` | Exposes the hub resource group name. | Automation scripts and documentation. |
| `spoke_resource_group_name` | Exposes the spoke resource group name. | Automation scripts and downstream configuration. |
| `hub_vnet_id` | Exposes the hub VNet resource ID. | Network and security automation. |
| `spoke_vnet_id` | Exposes the spoke VNet resource ID. | Downstream modules or environment references. |
| `hub_vnet_name` | Exposes the hub VNet name. | Logging, tagging, documentation. |
| `spoke_vnet_name` | Exposes the spoke VNet name. | Logging and integration. |
| `firewall_id` | Exposes Azure Firewall ID. | Diagnostics or network automation. |
| `spoke_subnet_id` | Exposes spoke subnet ID. | AKS and private endpoint resources. |
| `azure_firewall_private_ip` | Exposes firewall private IP. | Route table debugging and inspection. |
| `spoke_route_table_id` | Exposes route table ID. | Network automation and auditing. |
| `acr_name` | Exposes registry name. | CI pipelines and image push scripts. |
| `acr_login_server` | Exposes registry login server. | Container build and deploy pipelines. |
| `aks_identity_client_id` | Exposes managed identity client ID. | Identity and permission validation. |
| `aks_identity_principal_id` | Exposes managed identity principal ID. | RBAC assignment validation. |
| `acr_pull_role_assignment_id` | Exposes ACR pull role assignment resource ID. | Audit and drift detection. |
| `key_vault_name` | Exposes Key Vault name. | Secrets access and documentation. |
| `key_vault_id` | Exposes Key Vault resource ID. | Identity and RBAC automation. |
| `key_vault_uri` | Exposes Key Vault URI. | Application and secret retrieval. |
| `key_vault_private_dns_zone_id` | Exposes Key Vault private DNS zone ID. | DNS validation. |
| `acr_private_dns_zone_id` | Exposes ACR private DNS zone ID. | DNS validation. |
| `key_vault_private_endpoint_ip` | Exposes Key Vault private endpoint IP. | Network validation and troubleshooting. |
| `acr_private_endpoint_ip` | Exposes ACR private endpoint IP. | Network validation and troubleshooting. |
| `aks_name` | Exposes AKS cluster name. | Kubernetes CLI and automation. |
| `aks_id` | Exposes AKS resource ID. | Cleanup, audit, or integration. |
| `aks_oidc_issuer_url` | Exposes cluster OIDC issuer. | Workload identity and OIDC integration. |
| `aks_kubelet_identity_object_id` | Exposes kubelet identity object ID. | ACR pull RBAC assignment. |
| `agic_identity_object_id` | Exposes AGIC identity object ID. | App Gateway integration and permissions. |
| `app_gateway_id` | Exposes Application Gateway ID. | Ingress integration and automation. |
| `app_gateway_name` | Exposes Application Gateway name. | Documentation and post-deploy validation. |
| `app_gateway_public_ip` | Exposes App Gateway public IP resource. | DNS or external access validation. |

### `main.tf`
The `main.tf` file is the environment blueprint and orchestrates the module graph.

#### Locals
- `base_name`: computes a stable prefix from environment and project name.
- `hub_resource_group`, `spoke_resource_group`: names for hub/spoke RGs.
- `hub_vnet_name`, `spoke_vnet_name`: VNet names.
- `hub_subnet_name`, `spoke_subnet_name`: subnet names in hub and spoke.
- `spoke_route_table_name`: route table name for spoke outbound UDR.
- `app_gateway_subnet_name`: static required name for App Gateway subnet.
- `app_gateway_name`: application gateway resource name.

#### Resource Groups
- `module.hub_rg` creates the hub resource group.
- `module.spoke_rg` creates the spoke resource group.
- Purpose: separate shared services from workload resources and enable isolation.

#### VNets
- `module.hub_vnet` creates the hub VNet in the hub RG.
- `module.spoke_vnet` creates the spoke VNet in the spoke RG.
- Purpose: hub holds shared services and security controls; spoke holds AKS and private endpoints.

#### Peering
- `module.hub_to_spoke_peering` creates VNet peering from hub to spoke.
  - `allow_virtual_network_access = true` enables VNet-to-VNet traffic.
  - `allow_forwarded_traffic = true` allows forwarded traffic to cross the peering.
  - `allow_gateway_transit = true` enables the hub to provide gateway transit if a gateway exists.
- `module.spoke_to_hub_peering` creates VNet peering from spoke to hub.
  - `use_remote_gateways = true` forces spoke traffic to use hub routes and firewall.
  - `allow_virtual_network_access = true` and `allow_forwarded_traffic = true` allow full traffic flow between VNets.
- Purpose: create bidirectional hub-spoke connectivity and ensure traffic can traverse the hub security stack.

#### Subnets
- `module.hub_subnet` creates the shared hub subnet.
- `module.spoke_subnet` creates the spoke application subnet.
- `module.azure_firewall_subnet` creates the required `AzureFirewallSubnet` in the hub.
- `module.app_gateway_subnet` creates the required `AppGatewaySubnet` in the hub.
- Purpose: isolate hosts, firewall, and application gateway into dedicated network zones.

#### Firewall
- `module.azure_firewall` creates the Azure Firewall in the hub.
- The module creates:
  - a public IP for the firewall
  - a firewall policy with DNS proxy enabled
  - the Azure Firewall resource bound to the firewall subnet
  - application rule collections for trusted outbound domains
  - network rule collections for DNS and HTTPS traffic
- Purpose: enforce egress control for workloads and support secure DNS forwarding.

#### Route Tables
- `module.spoke_route_table` creates a route table with one route:
  - `0.0.0.0/0` points to the firewall private IP using `VirtualAppliance`
- `azurerm_subnet_route_table_association.spoke_subnet_rt` attaches the route table to the spoke subnet.
- Purpose: force outbound traffic from the spoke through the firewall for centralized inspection.

#### Log Analytics
- `module.log_analytics` creates the Log Analytics workspace.
- Purpose: collect telemetry and diagnostics from Azure Firewall and AKS.

#### Diagnostics
- `module.azure_firewall_diagnostics` attaches firewall diagnostics to Log Analytics.
- Enabled logs: `AzureFirewallApplicationRule`, `AzureFirewallNetworkRule`, `AzureFirewallDnsProxy`.
- Enabled metrics: `AllMetrics`.
- Purpose: provide observability into firewall actions and performance.

#### ACR
- `module.acr` creates Azure Container Registry in the spoke RG.
- SKU: `Premium`.
- Admin account: disabled.
- Purpose: store container images and enable secure pulls from AKS.

#### Managed Identity
- `module.aks_identity` creates a user-assigned managed identity.
- Purpose: allow AKS to authenticate to Azure resources without credentials.

#### Role Assignments
- `module.acr_pull_role` grants `AcrPull` to the AKS managed identity at the ACR scope.
- `module.kv_secrets_user_role` grants `Key Vault Secrets User` to the AKS managed identity at the Key Vault scope.
- Purpose: ensure least-privilege access for AKS to read images and secrets.

#### Key Vault
- `module.key_vault` creates Key Vault in the spoke RG.
- `enable_rbac_authorization = true` configures RBAC-based access control.
- `public_network_access_enabled = true` currently allows public access for management, but service access is secured using private endpoints.
- Purpose: manage secrets and certificates for workloads.

#### Private DNS
- `module.key_vault_private_dns_zone` creates a private DNS zone for Key Vault private endpoint resolution.
- `module.acr_private_dns_zone` creates a private DNS zone for ACR private endpoint resolution.
- Purpose: provide internal name resolution for private link resources.

#### Private Endpoints
- `module.key_vault_private_endpoint` attaches Key Vault to the spoke subnet privately.
- `module.acr_private_endpoint` attaches ACR to the spoke subnet privately.
- Purpose: ensure service traffic never leaves the VNet to reach ACR or Key Vault.

#### AKS
- `module.aks` creates the AKS cluster in the spoke RG.
- Important settings:
  - `private_cluster_enabled = true`: prevents public API server exposure.
  - `oidc_issuer_enabled = true`: enables OIDC issuer for workload identity.
  - `workload_identity_enabled = true`: enables Azure AD workload identity.
  - `identity.type = "UserAssigned"`: uses a user-assigned managed identity.
  - `oms_agent`: connects the cluster to Log Analytics.
  - `network_profile`:
    - `network_plugin = "azure"`
    - `network_plugin_mode = "overlay"`
    - `network_policy = "azure"`
    - `service_cidr` and `dns_service_ip` are configured from variables
    - `outbound_type = "userDefinedRouting"` ensures node egress uses the route table and firewall
  - `ingress_application_gateway` is enabled when `enable_agic` is true.
- Purpose: run container workloads securely with integrated Azure networking and monitoring.

#### AGIC
- `module.aks_kubelet_acr_pull_role` grants the AKS kubelet identity `AcrPull` at ACR scope.
- `module.app_gateway` creates the Application Gateway in the hub.
- `module.agic_appgw_contributor_role` grants the AGIC identity `Contributor` to the Application Gateway.
- Purpose: allow AKS ingress resources to configure Application Gateway routing.

---

## 4. Module Documentation

### Resource Group Module
#### Purpose
Creates an Azure resource group to logically group resources by lifecycle and purpose.

#### Inputs
- `name`: resource group name
- `location`: Azure region
- `tags`: metadata tags

#### Outputs
- `resource_group_name`: created RG name
- `resource_group_id`: created RG ID
- `location`: RG location

#### Resources created
- `azurerm_resource_group.this`

#### Dependencies
None beyond provider initialization.

#### Example usage
```hcl
module "hub_rg" {
  source   = "../../modules/resource-group"
  name     = local.hub_resource_group
  location = var.location
  tags     = var.tags
}
```

### VNet Module
#### Purpose
Creates a virtual network with a defined address space.

#### Inputs
- `name`: VNet name
- `location`: Azure region
- `resource_group_name`: resource group name
- `address_space`: list of CIDR ranges
- `tags`: metadata tags

#### Outputs
- `vnet_id`: VNet resource ID
- `vnet_name`: VNet name

#### Resources created
- `azurerm_virtual_network.this`

#### Notes
- Address space should not overlap with other VNets in the subscription if those VNets are meant to peer.
- Hub and spoke are intentionally separate address spaces.

### Subnet Module
#### Purpose
Creates an Azure subnet associated with a VNet.

#### Inputs
- `name`: subnet name
- `resource_group_name`: RG containing the VNet
- `virtual_network_name`: VNet name
- `address_prefixes`: CIDR(s) for the subnet
- `service_endpoints`: optional service endpoints

#### Outputs
- `subnet_id`: subnet resource ID
- `subnet_name`: subnet name

#### Resources created
- `azurerm_subnet.this`

#### Notes
- `AzureFirewallSubnet` and `AppGatewaySubnet` must have the exact required names.
- For AKS, `vnet_subnet_id` is used to deploy node pools into the spoke subnet.

### VNet Peering Module
#### Purpose
Installs an Azure VNet peering relationship between two VNets.

#### Inputs
- `name`: peering resource name
- `resource_group_name`: RG where the local VNet exists
- `virtual_network_name`: local VNet name
- `remote_virtual_network_id`: target remote VNet ID
- `allow_virtual_network_access`: enables VNet communication
- `allow_forwarded_traffic`: allows traffic forwarded from appliances
- `allow_gateway_transit`: allows the local VNet to provide gateway transit
- `use_remote_gateways`: allows the local VNet to use the peer's gateway

#### Resources created
- `azurerm_virtual_network_peering.this`

#### Traffic flow diagram
```
Hub VNet ------------------- Spoke VNet
   |                                |
   |-- allow_virtual_network_access ->|
   |<-- allow_virtual_network_access -|
   |-- allow_forwarded_traffic ----->|
   |<-- allow_forwarded_traffic ---- |
   |-- allow_gateway_transit ------->|
   |<-- use_remote_gateways ---------|
```

#### Explanation
- `allow_virtual_network_access`: required for direct traffic between hub and spoke.
- `allow_forwarded_traffic`: needed when traffic is routed through Azure Firewall or other appliances.
- `allow_gateway_transit`: allows the hub to act as a central gateway provider.
- `use_remote_gateways`: allows the spoke to route traffic through the hub firewall or gateway.

### Azure Firewall Module
#### Purpose
Creates Azure Firewall with associated policy and rule collections.

#### Inputs
- `name`: firewall resource name
- `location`: Azure region
- `resource_group_name`: RG for the firewall
- `firewall_subnet_id`: subnet ID for Azure Firewall
- `sku_tier`: firewall SKU tier
- `tags`: metadata tags
- `source_addresses`: list of source CIDR prefixes permitted by the rules

#### Outputs
- `firewall_id`: firewall resource ID
- `firewall_private_ip`: private IP of the firewall
- `firewall_public_ip`: public IP address of the firewall
- `firewall_policy_id`: firewall policy ID

#### Resources created
- `azurerm_public_ip.this`
- `azurerm_firewall_policy.this`
- `azurerm_firewall.this`
- `azurerm_firewall_policy_rule_collection_group.this`

#### Firewall policy and DNS proxy
- `azurerm_firewall_policy.this` enables `dns.proxy_enabled = true`.
- This means the firewall can inspect DNS requests and use defined DNS rules if added.

#### Rule Collection Groups
- `application_rule_collection` named `allow-dev-web`
  - `allow-websites` allows HTTP/HTTPS outbound access to configured FQDNs from `source_addresses`.
  - Destination FQDNs include Microsoft, Azure, Ubuntu, Docker, GitHub, login.microsoftonline.com, and management.azure.com.
- `network_rule_collection` named `allow-dev-network`
  - `allow-dns` allows TCP/UDP port 53 to Google and Cloudflare public DNS servers.
  - `allow-https` allows HTTPS outbound to any destination.

#### Traffic flow
1. Workloads in the spoke send outbound traffic.
2. Spoke route table sends default traffic to Azure Firewall.
3. Firewall evaluates traffic against network and application rules.
4. Allowed HTTP/HTTPS and DNS traffic are forwarded to the internet.

### Route Table Module
#### Purpose
Creates a route table and routes for subnet traffic control.

#### Inputs
- `name`: route table name
- `location`: Azure region
- `resource_group_name`: RG for the route table
- `tags`: metadata tags
- `routes`: list of route objects

#### Outputs
- none required beyond route table resource

#### Resources created
- `azurerm_route_table.this`
- `azurerm_route.this` for each route

#### Route explanation
- UDR: user-defined route for `0.0.0.0/0` directs outbound traffic.
- `next_hop_type = "VirtualAppliance"`: indicates traffic should go to a firewall or virtual appliance.
- `next_hop_in_ip_address`: uses the firewall private IP.

#### Why traffic goes through firewall
- Ensures all outbound traffic from the spoke is inspected and controlled.
- Prevents workload bypass of centralized security policies.

### Log Analytics Module
#### Purpose
Creates a Log Analytics workspace for platform and application diagnostics.

#### Inputs
- `name`: workspace name
- `location`: Azure region
- `resource_group_name`: RG name
- `sku`: workspace SKU
- `retention_in_days`: retention window
- `tags`: metadata tags

#### Outputs
- `workspace_id`: Log Analytics workspace ID
- `workspace_name`: workspace name
- `workspace_customer_id`: workspace customer ID

#### Resources created
- `azurerm_log_analytics_workspace.this`

#### Notes
- AKS OMS Agent sends cluster logs to this workspace.
- Firewall diagnostic settings loop into this workspace for event capture.

### Diagnostic Settings Module
#### Purpose
Binds Azure resource diagnostics to Log Analytics.

#### Inputs
- `name`: diagnostic settings name
- `target_resource_id`: resource to monitor
- `log_analytics_workspace_id`: workspace ID
- `enabled_logs`: list of log categories
- `enabled_metrics`: list of metrics categories

#### Resources created
- `azurerm_monitor_diagnostic_setting.this`

#### Notes
- This module is currently used for firewall diagnostics.
- It ensures log categories and metrics are captured for troubleshooting and security.

### ACR Module
#### Purpose
Creates Azure Container Registry for container image storage.

#### Inputs
- `name`: registry name
- `resource_group_name`: RG for ACR
- `location`: Azure region
- `sku`: registry SKU
- `admin_enabled`: whether admin credentials are enabled
- `tags`: metadata tags

#### Outputs
- `acr_id`: ACR resource ID
- `acr_name`: ACR registry name
- `acr_login_server`: ACR login server DNS name

#### Resources created
- `azurerm_container_registry.this`

#### Notes
- `Premium` SKU supports private endpoints and higher throughput.
- `admin_enabled = false` enforces more secure authentication patterns.
- Image lifecycle: build images, push to ACR, then AKS pulls images based on RBAC credentials.

### Managed Identity Module
#### Purpose
Creates a user-assigned managed identity for AKS.

#### Inputs
- `name`: identity name
- `location`: region
- `resource_group_name`: RG
- `tags`: metadata tags

#### Outputs
- `id`: identity resource ID
- `name`: identity name
- `client_id`: identity client ID
- `principal_id`: identity principal ID

#### Resources created
- `azurerm_user_assigned_identity.this`

#### Notes
- The identity is assigned to AKS for RBAC and Azure resource access.
- It is separate from the AKS cluster-managed identity, supporting clear ownership.

### Role Assignment Module
#### Purpose
Creates an Azure RBAC role assignment.

#### Inputs
- `scope`: resource or subscription scope
- `role_definition_name`: RBAC role name
- `principal_id`: object ID of the principal

#### Resources created
- `azurerm_role_assignment.this`

#### Notes
- This module is used to grant AKS and AGIC permissions to ACR, Key Vault, and Application Gateway.
- It supports least-privilege models by scoping roles to a specific resource.

### Key Vault Module
#### Purpose
Creates Azure Key Vault with RBAC authorization.

#### Inputs
- `name`: Key Vault name
- `location`: region
- `resource_group_name`: RG
- `tenant_id`: Azure tenant ID
- `sku_name`: vault SKU
- `public_network_access_enabled`: whether public network access is allowed
- `purge_protection_enabled`: purge protection toggle
- `soft_delete_retention_days`: soft delete retention window
- `tags`: metadata tags

#### Outputs
- `key_vault_id`: Key Vault resource ID
- `key_vault_name`: Key Vault name
- `key_vault_uri`: Key Vault URI

#### Resources created
- `azurerm_key_vault.this`

#### Notes
- RBAC authorization avoids access policy complexity and centralizes access control.
- The module is prepared for private endpoint integration via a separate private endpoint module.

### Private DNS Module
#### Purpose
Creates a private DNS zone and links it to a VNet.

#### Inputs
- `name`: private DNS zone name
- `resource_group_name`: RG
- `virtual_network_id`: VNet to link
- `tags`: metadata tags

#### Outputs
- `private_dns_zone_id`: zone ID
- `private_dns_zone_name`: zone name

#### Resources created
- `azurerm_private_dns_zone.this`
- `azurerm_private_dns_zone_virtual_network_link.this`

#### Notes
- Private DNS zones are required for service endpoint name resolution when using private endpoints.
- The zones do not register VM hostnames (`registration_enabled = false`).

### Private Endpoint Module
#### Purpose
Creates a private endpoint for Azure services.

#### Inputs
- `name`: endpoint name
- `location`: region
- `resource_group_name`: RG
- `subnet_id`: target subnet ID
- `private_connection_resource_id`: resource to connect privately
- `subresource_names`: service-specific subresource names
- `private_dns_zone_ids`: private DNS zone IDs to register
- `tags`: metadata tags

#### Outputs
- `private_endpoint_id`: endpoint resource ID
- `private_endpoint_name`: endpoint name
- `private_endpoint_private_ip`: private IP assigned to endpoint

#### Resources created
- `azurerm_private_endpoint.this`

#### Notes
- Private endpoints move service traffic into the VNet and eliminate exposure to the public internet.
- DNS is resolved through linked private DNS zones.

### AKS Module
#### Purpose
Creates an Azure Kubernetes Service cluster with secure networking and observability.

#### Inputs
- `name`, `location`, `resource_group_name`, `dns_prefix`
- `kubernetes_version`: optional cluster version
- `private_cluster_enabled`: enable private API server
- `oidc_issuer_enabled`: enable OIDC issuer
- `workload_identity_enabled`: enable workload identity
- `default_node_pool_name`: node pool name
- `node_count`: nodes in the default pool
- `vm_size`: node VM size
- `vnet_subnet_id`: subnet for AKS nodes
- `user_assigned_identity_id`: managed identity ID
- `log_analytics_workspace_id`: workspace ID for OMS agent
- `network_plugin`: `azure`
- `network_plugin_mode`: `overlay`
- `network_policy`: `azure`
- `service_cidr`, `dns_service_ip`, `outbound_type`
- `enable_agic`: enable App Gateway integration
- `application_gateway_id`: App Gateway ID for AGIC
- `tags`

#### Outputs
- `aks_id`: AKS resource ID
- `aks_name`: cluster name
- `kubelet_identity_object_id`: kubelet identity object ID
- `oidc_issuer_url`: OIDC issuer URL
- `agic_identity_object_id`: AGIC identity object ID if enabled

#### Resources created
- `azurerm_kubernetes_cluster.this`

#### AKS configuration rationale
- `private_cluster_enabled = true`: removes public API server endpoint, improving control over management access.
- `oidc_issuer_enabled = true`: enables service account-based identity federation.
- `workload_identity_enabled = true`: integrates Kubernetes workloads with Azure AD securely.
- `identity.type = "UserAssigned"`: uses a dedicated, reusable identity instead of system-assigned identity.
- `oms_agent`: forwards logs and metrics to Log Analytics.
- `network_plugin = "azure"` with `overlay` mode: enables Azure CNI overlay networking to simplify pod networking and future network policy compatibility.
- `network_policy = "azure"`: enforces Kubernetes network policy at the Azure level.
- `outbound_type = "userDefinedRouting"`: ensures outbound egress follows the UDR and firewall path.
- `ingress_application_gateway`: integrates Application Gateway with AKS for ingress resource management.

### Application Gateway Module
#### Purpose
Creates an Application Gateway as the public ingress layer.

#### Inputs
- `name`, `location`, `resource_group_name`, `subnet_id`
- `sku_name`, `sku_tier`, `capacity`
- `tags`

#### Outputs
- `application_gateway_id`
- `application_gateway_name`
- `application_gateway_public_ip`

#### Resources created
- `azurerm_public_ip.appgw_ip`
- `azurerm_application_gateway.this`

#### Configuration details
- `sku`: `Standard_v2` provides modern Application Gateway features and performance.
- `ssl_policy`: `AppGwSslPolicy20220101` applies a strong default TLS policy.
- `gateway_ip_configuration`: attaches App Gateway to the `AppGatewaySubnet`.
- `frontend_port`: listens on port 80.
- `frontend_ip_configuration`: binds a public IP.
- `backend_address_pool`: a default backend pool for future workloads.
- `backend_http_settings`: default HTTP settings for backend traffic.
- `http_listener`: listens for inbound HTTP requests.
- `request_routing_rule`: basic routing rule that sends all HTTP traffic to the default backend pool.

#### WAF and TLS
- This module currently provisions Application Gateway without a dedicated WAF policy block.
- Future enterprise deployments should enable WAF, custom TLS certificates, and private listeners as needed.

### AGIC
#### What AGIC is
AGIC (Azure Application Gateway Ingress Controller) is the Azure-native integration that allows Kubernetes ingress resources to configure Application Gateway routing automatically.

#### How it integrates with AKS
- The AKS cluster is configured with `ingress_application_gateway` pointing to the Application Gateway resource.
- When enabled, AKS creates a managed identity for AGIC and grants it permissions on the Application Gateway.
- Kubernetes ingress objects are translated into Application Gateway listeners, rules, and backend pools.

#### How ingress resources update Application Gateway
- A Kubernetes ingress resource is created in the cluster.
- AGIC watches the ingress resource and converts its rules into Azure Application Gateway configuration.
- Application Gateway is updated automatically without manual rule changes in Azure.

> Note: The repository includes an unused `modules/agic-add-on/` module; the current environment uses built-in AKS ingress integration instead.

---

## 5. Architecture Diagrams

### High-Level Architecture

```
Internet
   |
   v
Application Gateway (AppGw)
   |
   v
Azure Firewall (Hub)
   |
   v
Hub VNet
   |  \ 
   |   \__ Log Analytics
   |    \__ ACR (private endpoint)
   |    \__ Key Vault (private endpoint)
   |
   v
Spoke VNet
   |
   v
AKS Cluster
   |
   v
Pods / Workloads
```

### Network Architecture

```
Hub VNet
  ├─ AzureFirewallSubnet [Azure Firewall]
  ├─ AppGatewaySubnet [Application Gateway]
  └─ Shared Hub Subnet

Spoke VNet
  ├─ AKS / workload subnet
  ├─ Private Endpoint to ACR
  ├─ Private Endpoint to Key Vault
  └─ Route Table -> Firewall

Peering:
  Hub <--> Spoke
    - allow_virtual_network_access
    - allow_forwarded_traffic
    - allow_gateway_transit (hub)
    - use_remote_gateways (spoke)
```

### AKS Architecture

```
AKS Cluster (Private)
  ├─ Default node pool
  ├─ User-assigned identity
  ├─ Workload identity / OIDC
  ├─ Azure CNI overlay
  ├─ Azure network policy
  └─ OMS Agent -> Log Analytics

Ingress flow:
  Internet -> App Gateway -> AGIC -> AKS ingress -> Service -> Pod
```

### Identity Architecture

```
GitHub Actions / CI
  └─ Azure AD / Service Principal or OIDC
        |
        v
 AKS User Assigned Identity
        |
        +-- AcrPull on ACR
        +-- Key Vault Secrets User on Key Vault
        +-- AGIC Contributor on App Gateway

AKS kubelet identity
  └-- AcrPull on ACR
```

---

## 6. Deployment Guide

### 1. Initialize Terraform
```bash
terraform init
```
- Downloads modules and provider plugins.
- Prepares the backend and local working directory.

### 2. Format configuration
```bash
terraform fmt -recursive
```
- Normalizes Terraform code formatting.
- Ensures consistent style across modules and environment files.

### 3. Validate configuration
```bash
terraform validate
```
- Checks syntax and provider/module references.
- Detects invalid or missing values before planning.

### 4. Create an execution plan
```bash
terraform plan -var-file=envs/dev/terraform.tfvars
```
- Shows the expected changes without applying them.
- Validates variable values and resource arguments.

### 5. Apply changes
```bash
terraform apply -var-file=envs/dev/terraform.tfvars
```
- Provisions Azure resources according to the plan.
- Prompts for approval before execution.

> For production, use a remote state backend and a managed service principal or GitHub OIDC authentication.

---

## 7. Terraform Dependency Graph

The infrastructure is created in a logical order based on module dependencies.

1. Resource Group
2. VNet
3. Subnet
4. VNet Peering
5. Azure Firewall
6. Route Table
7. Log Analytics
8. Diagnostics
9. ACR
10. Managed Identity
11. Role Assignments
12. Key Vault
13. Private DNS
14. Private Endpoint
15. AKS
16. Application Gateway
17. AGIC / App Gateway permissions

This order is enforced automatically by Terraform through module input/output references.

---

## 8. Security Design

### Firewall
- Centralized Azure Firewall inspects outbound traffic.
- Application rules restrict outbound HTTP/HTTPS to approved FQDNs.
- Network rules allow DNS and HTTPS only.
- DNS proxy is enabled to improve private DNS control.

### RBAC
- Uses Azure role assignments scoped to specific resources.
- `AcrPull` is granted only to the AKS identity and kubelet identity.
- `Key Vault Secrets User` is granted only to the AKS identity.
- `Contributor` is granted only to the AGIC identity on the Application Gateway.

### Managed Identities
- AKS uses a user-assigned managed identity for resource access.
- Workload identity and OIDC eliminate static secrets in the cluster.
- Identity assignments are explicit and scoped.

### Private Endpoints
- ACR and Key Vault access is routed through private endpoints.
- Services do not require public endpoint access for application traffic.
- Private DNS zones resolve private links in the spoke VNet.

### Private DNS
- Private DNS zones maintain internal resolution for platform services.
- Zones are linked to the spoke VNet.
- This prevents public DNS lookups from leaking private service traffic.

### Key Vault
- RBAC authorization is enabled instead of access policies.
- Soft delete and purge protection are configured by default in module inputs.
- Key Vault can be hardened further by disabling public access entirely.

### Workload Identity
- OIDC and workload identity provide secure pod-to-Azure authentication.
- This allows Kubernetes workloads to access Azure resources without secrets.

---

## 9. Operational Runbook

### Troubleshoot AKS
- Verify cluster exists: `az aks show --name <cluster> --resource-group <rg>`
- Check node pool status: `kubectl get nodes`
- Confirm private cluster API access: ensure network contains route to cluster API and you use Azure Bastion or VPN.
- Inspect pod logs: `kubectl logs <pod>`
- Review cluster events: `kubectl get events --all-namespaces`
- Verify Log Analytics connectivity if OMS agent data is missing.

### Troubleshoot ACR pulls
- Confirm `AcrPull` role assignment: check ACR IAM for the AKS identity.
- Validate ACR private endpoint DNS resolution: `nslookup <registry>.azurecr.io` from a pod or VM in the spoke VNet.
- Confirm ACR service is reachable privately through the private endpoint.
- If using `imagePullSecrets`, ensure registry identity and AKS configuration match.

### Troubleshoot Key Vault access
- Verify Key Vault RBAC roles: `Key Vault Secrets User` should be assigned to the AKS identity.
- Confirm private endpoint connectivity and private DNS resolution.
- Test access from a pod using Azure identity authentication.
- Inspect Key Vault activity logs in Azure Monitor or Log Analytics.

### Troubleshoot AGIC
- Confirm AGIC is enabled in AKS by checking cluster configuration.
- Verify `agic_identity_object_id` has `Contributor` on the Application Gateway.
- Inspect Kubernetes ingress resources and AGIC logs.
- Confirm Application Gateway configuration matches ingress definitions.
- If changes are not reflected, restart AGIC or reapply ingress.

### Troubleshoot Application Gateway
- Verify public IP is provisioned and frontend listener is healthy.
- Check backend health in the Application Gateway blade.
- Review App Gateway diagnostics if enabled.
- Confirm routing rules and listeners exist.
- Ensure App Gateway is deployed in the correct subnet and the subnet has no conflicting resources.

### Troubleshoot Terraform state
- Confirm backend configuration in `backend.tf`.
- If using local state, ensure `terraform.tfstate` is present and protected.
- For remote backends, verify access to the storage account or Terraform Cloud workspace.
- Use `terraform plan` and `terraform refresh` to validate state.
- Resolve drift by comparing actual Azure resources with expected Terraform state.

---

## 10. Future Enhancements

### Recommended platform improvements
- Enable Azure Application Gateway WAF or migrate to `WAF_v2` for application protection.
- Add GitHub Actions OIDC or Azure DevOps service principal automation for CI/CD.
- Deploy Argo CD or Flux for GitOps-driven Kubernetes application delivery.
- Add ExternalDNS to synchronize Kubernetes ingress DNS records with Azure DNS.
- Install cert-manager for automated TLS certificate lifecycle management.
- Expand Azure Monitor and alerting rules for cluster and firewall telemetry.
- Enable Defender for Cloud for additional platform protection.
- Add backup and recovery for Key Vault, ACR, and AKS cluster configurations.
- Define a DR strategy for hub-spoke networking and critical workloads.

### Suggested architectural extensions
- Add a separate shared services spoke for DNS, jump boxes, or monitoring gateways.
- Introduce Azure Bastion or VPN connectivity for private cluster management.
- Add a dedicated ingress cluster or add a second AKS workload cluster for production.
- Use an Azure Storage backend with state locking for environment remote state.
- Harden Key Vault by disabling public network access after private endpoints are fully validated.

---

## Notes
- This README is designed to support both beginners and senior platform engineering teams.
- The current `dev` environment is a working blueprint; adjust values and backends for production use.
- Review each module and security setting before deploying in a live environment.
