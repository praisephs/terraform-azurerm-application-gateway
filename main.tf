resource "azurerm_application_gateway" "this" {

  name                = var.application_gateway_name
  resource_group_name = var.virtual_network_resource_group_name
  location            = var.location

  sku {
    name     = var.sku["name"]
    tier     = var.sku["tier"]
    capacity = var.sku["capacity"]
  }

  gateway_ip_configuration {

    name      = var.gateway_ip_configuration["name"]
    subnet_id = var.gateway_ip_configuration["subnet_id"]

  }

  dynamic "frontend_port" {
    for_each = var.frontend_port

    content {
      name = frontend_port.value.name
      port = frontend_port.value.port

    }
  }

  frontend_ip_configuration {
    name                            = var.frontend_ip_configuration["name"]
    public_ip_address_id            = var.frontend_ip_configuration["public_ip_address_id"]
    private_ip_address              = var.frontend_ip_configuration["private_ip_address"]
    private_ip_address_allocation   = var.frontend_ip_configuration["private_ip_address_allocation"]
    private_link_configuration_name = var.frontend_ip_configuration["private_link_configuration_name"]
  }

  dynamic "backend_address_pool" {
    for_each = toset(var.backend_address_pool_names)

    content {
      name = backend_address_pool.value

    }

  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings

    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      probe_name                          = backend_http_settings.value.probe_name
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      host_name                           = backend_http_settings.value.host_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      trusted_root_certificate_names      = backend_http_settings.value.trusted_root_certificate_names

    }

  }

  dynamic "http_listener" {
    for_each = var.http_listener

    content {

      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      host_names                     = http_listener.value.host_names
      require_sni                    = http_listener.value.require_sni
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
      firewall_policy_id             = http_listener.value.firewall_policy_id
      ssl_profile_name               = http_listener.value.ssl_profile_name
    }

  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule

    content {

      name                        = request_routing_rule.value.name
      priority                    = request_routing_rule.value.priority
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
      url_path_map_name           = request_routing_rule.value.url_path_map_name

    }

  }

}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "this" {
  for_each = var.network_interfaces


  network_interface_id    = each.value.id
  ip_configuration_name   = each.value.ip_configuration[0].name
  backend_address_pool_id = [for pool in azurerm_application_gateway.this.backend_address_pool : pool.id if pool.name == trimprefix(each.value.ip_configuration[0].name, "ip-")][0]

}


