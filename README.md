# Perizer Terraform Module Template Repo
This is the base Terraform Module Template Repo used for creating new Terraform modules.

## Benefits of Terraform Module
- Reusability and Standardization: Use pre-defined infrastructure components for consistent deployments.
- Consistency and Scalability: Provision infrastructure reliably and scale deployments efficiently.
- Collaboration and Efficiency: Foster collaboration, code reuse, and best practices.
- Maintainability and Upgradability: Simplify maintenance and updates of infrastructure configurations.
- Versioning and Testing: Track changes, validate functionality, and ensure compatibility.
- Governance and Compliance: Enforce governance and comply with security and industry requirements.

## Release Description
# This is a release description template that should be updated for each release.

# Terraform AzureRM Module - Release X.X.X
Release Date: YYYY-MM-DD

## Changelog
Summarize the major changes and updates made in this release. Provide a high-level overview of new features, enhancements, and bug fixes.

## New Features
- Feature 1: Description of the new feature.
- Feature 2: Description of the new feature.

## Enhancements
- Enhancement 1: Description of the enhancement.
- Enhancement 2: Description of the enhancement.

## Bug Fixes
- Bug Fix 1: Description of the bug fix.
- Bug Fix 2: Description of the bug fix.

## Breaking Changes
- List any changes that might affect the existing infrastructure or configurations. Provide guidance on how users can update their existing deployments to adapt to these changes.

## Compatibility
- Describe the compatibility of this module with different versions of Terraform, AzureRM provider, and any other dependencies.

## Installation
- Instructions and dependencies can be found in the updated README.md.

## Usage Examples
- Provide updated examples on how to use the module effectively in different scenarios.

## Documentation
- Updated README with comprehensive module usage instructions and detailed input output descriptions.
- Linked to Azure documentation for additional context and resources.

## Support
- For any questions or issues related to this module, please create a JIRA [ticket](https://perizer.atlassian.net/jira/software/c/projects/CLOUD/boards/11).


## Versioning
- [Semantic versioning](https://semver.org/#semantic-versioning-200), Given a version number MAJOR.MINOR.PATCH, increment the:
    - MAJOR version when you make incompatible API changes
    - MINOR version when you add functionality in a backward compatible manner
    - PATCH version when you make backward compatible bug fixes

---
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.63.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~>0.9.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_gateway_name"></a> [application\_gateway\_name](#input\_application\_gateway\_name) | (Required) The name of the Application Gateway. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_backend_address_pool_names"></a> [backend\_address\_pool\_names](#input\_backend\_address\_pool\_names) | The name of the backend address pool | `list(string)` | n/a | yes |
| <a name="input_frontend_ip_configuration"></a> [frontend\_ip\_configuration](#input\_frontend\_ip\_configuration) | n/a | `map(string)` | n/a | yes |
| <a name="input_gateway_ip_configuration"></a> [gateway\_ip\_configuration](#input\_gateway\_ip\_configuration) | (Required) The Name of this Gateway IP Configuration. | `map(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure location where the App Gateway should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | (Required) The name of the Network Interface. Changing this forces a new resource to be created. | `any` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | sku to use for the App Gateway | `map(string)` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | (Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | (Required) The name of the Backend HTTP Settings Collection. | <pre>map(object({<br>    name                                = string<br>    cookie_based_affinity               = string<br>    affinity_cookie_name                = optional(string)<br>    path                                = optional(string)<br>    port                                = number<br>    probe_name                          = optional(string)<br>    protocol                            = string<br>    request_timeout                     = optional(number)<br>    host_name                           = optional(string)<br>    pick_host_name_from_backend_address = optional(string)<br>    trusted_root_certificate_names      = optional(list(string))<br><br>  }))</pre> | <pre>{<br>  "backend_http_settings_1": {<br>    "affinity_cookie_name": null,<br>    "authentication_certificate": null,<br>    "cookie_based_affinity": "Disabled",<br>    "host_name": "",<br>    "name": "web-backend-http",<br>    "path": "/",<br>    "pick_host_name_from_backend_address": null,<br>    "port": 80,<br>    "probe_name": null,<br>    "protocol": "Http",<br>    "request_timeout": null<br>  }<br>}</pre> | no |
| <a name="input_frontend_port"></a> [frontend\_port](#input\_frontend\_port) | Frontend port of the App Gateway | <pre>map(object({<br>    name = string<br>    port = number<br>  }))</pre> | <pre>{<br>  "80": {<br>    "name": "dev-1",<br>    "port": 80<br>  }<br>}</pre> | no |
| <a name="input_http_listener"></a> [http\_listener](#input\_http\_listener) | (Required) The Name of the HTTP Listener. | <pre>map(object({<br>    name                           = string<br>    host_names                     = optional(list(string))<br>    require_sni                    = optional(bool)<br>    ssl_certificate_name           = optional(string)<br>    firewall_policy_id             = optional(string)<br>    ssl_profile_name               = optional(string)<br>    protocol                       = string<br>    frontend_ip_configuration_name = string<br>    frontend_port_name             = string<br>  }))</pre> | <pre>{<br>  "http_listener-1": {<br>    "firewall_policy_id": null,<br>    "frontend_ip_configuration_name": null,<br>    "frontend_port_name": null,<br>    "host_names": [<br>      "*"<br>    ],<br>    "name": "web-listener",<br>    "protocol": "Http",<br>    "require_sni": false,<br>    "ssl_certificate_name": null,<br>    "ssl_profile_name": null<br>  }<br>}</pre> | no |
| <a name="input_request_routing_rule"></a> [request\_routing\_rule](#input\_request\_routing\_rule) | (Required) The Name of this Request Routing Rule. | <pre>map(object({<br>    name                        = string<br>    priority                    = number<br>    rule_type                   = string<br>    http_listener_name          = string<br>    backend_address_pool_name   = string<br>    backend_http_settings_name  = string<br>    redirect_configuration_name = optional(string)<br>    rewrite_rule_set_name       = optional(string)<br>    url_path_map_name           = optional(string)<br>  }))</pre> | <pre>{<br>  "request_routing_rule_1": {<br>    "backend_address_pool_name": "web-backend-address",<br>    "backend_http_settings_name": "web-backend-http",<br>    "http_listener_name": "web-listerner",<br>    "name": "web-request",<br>    "priority": 9,<br>    "redirect_configuration_name": null,<br>    "rewrite_rule_set_name": null,<br>    "rule_type": "Basic",<br>    "url_path_map_name": null<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_gateway_out"></a> [app\_gateway\_out](#output\_app\_gateway\_out) | n/a |
| <a name="output_network_interface_debug"></a> [network\_interface\_debug](#output\_network\_interface\_debug) | n/a |
<!-- END_TF_DOCS -->