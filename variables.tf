variable "virtual_network_resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."

}

variable "location" {
  type        = string
  description = "(Required) The Azure location where the App Gateway should exist. Changing this forces a new resource to be created."

}

variable "application_gateway_name" {
  type        = string
  description = "(Required) The name of the Application Gateway. Changing this forces a new resource to be created."

}

variable "sku" {
  type        = map(string)
  description = "sku to use for the App Gateway"

}

variable "gateway_ip_configuration" {
  type        = map(string)
  description = "(Required) The Name of this Gateway IP Configuration."

}

variable "frontend_port" {
  type = map(object({
    name = string
    port = number
  }))
  default = {
    "80" = {
      name = "dev-1"
      port = 80

    }
  }

  description = "Frontend port of the App Gateway"
}

variable "frontend_ip_configuration" {
  type = map(string)

}

variable "backend_http_settings" {
  type = map(object({
    name                                = string
    cookie_based_affinity               = string
    affinity_cookie_name                = optional(string)
    path                                = optional(string)
    port                                = number
    probe_name                          = optional(string)
    protocol                            = string
    request_timeout                     = optional(number)
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(string)
    trusted_root_certificate_names      = optional(list(string))

  }))

  default = {
    "backend_http_settings_1" = {
      name                                = "web-backend-http"
      cookie_based_affinity               = "Disabled"
      affinity_cookie_name                = null
      path                                = "/"
      port                                = 80
      probe_name                          = null
      protocol                            = "Http"
      request_timeout                     = null
      host_name                           = ""
      pick_host_name_from_backend_address = null
      authentication_certificate          = null

    }
  }
  description = "(Required) The name of the Backend HTTP Settings Collection."

}

variable "http_listener" {
  type = map(object({
    name                           = string
    host_names                     = optional(list(string))
    require_sni                    = optional(bool)
    ssl_certificate_name           = optional(string)
    firewall_policy_id             = optional(string)
    ssl_profile_name               = optional(string)
    protocol                       = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
  }))
  default = {
    "http_listener-1" = {
      name                           = "web-listener"
      host_names                     = ["*"]
      require_sni                    = false
      ssl_certificate_name           = null
      firewall_policy_id             = null
      ssl_profile_name               = null
      protocol                       = "Http"
      frontend_ip_configuration_name = null
      frontend_port_name             = null
    }
  }
  description = "(Required) The Name of the HTTP Listener."

}

variable "request_routing_rule" {
  type = map(object({
    name                        = string
    priority                    = number
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    url_path_map_name           = optional(string)
  }))

  default = {
    "request_routing_rule_1" = {
      name                        = "web-request"
      priority                    = 9
      rule_type                   = "Basic"
      http_listener_name          = "web-listerner"
      backend_address_pool_name   = "web-backend-address"
      backend_http_settings_name  = "web-backend-http"
      redirect_configuration_name = null
      rewrite_rule_set_name       = null
      url_path_map_name           = null

    }
  }
  description = "(Required) The Name of this Request Routing Rule."

}

variable "network_interfaces" {
  type = any

  description = "(Required) The name of the Network Interface. Changing this forces a new resource to be created."
}


variable "backend_address_pool_names" {
  type        = list(string)
  description = "The name of the backend address pool"

}