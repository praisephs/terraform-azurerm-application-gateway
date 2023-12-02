data "azurerm_resource_group" "this" {
  name = "app-gw-demo"
}

data "azurerm_virtual_network" "this" {
  name                = "app-gw-demo-vnet"
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "frontend_subnet" {
  name                 = "frontend-subnet"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
}

data "azurerm_subnet" "nic_app_gw_subnet" {
  name                 = "nic-app-gw-subnet"
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
}

resource "azurerm_public_ip" "this" {
  name                = "my-pip"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_network_interface" "this" {
  for_each = var.vm_instances

  name                = "nic-${each.value.name}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "ip-${each.value.backend_pool_name}"
    subnet_id                     = data.azurerm_subnet.nic_app_gw_subnet.id
    private_ip_address_allocation = each.value.private_ip_address_allocation

  }

}

resource "azurerm_linux_virtual_machine" "this" {

  for_each = var.vm_instances

  name                            = each.value.name
  location                        = data.azurerm_resource_group.this.location
  resource_group_name             = data.azurerm_resource_group.this.name
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "AdminUser1234"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.this[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  depends_on = [azurerm_network_interface.this]
}

resource "azurerm_network_security_group" "this" {
  name                = var.nsg
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "this" {
  for_each = var.nsg_rules

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port
  destination_port_range      = each.value.dest_port
  source_address_prefix       = each.value.source_addr
  destination_address_prefix  = each.value.dest_addr
  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = data.azurerm_subnet.nic_app_gw_subnet.id
  network_security_group_id = azurerm_network_security_group.this.id
}

module "app_gateway" {

  source = "../"

  virtual_network_resource_group_name = data.azurerm_virtual_network.this.resource_group_name
  location                            = data.azurerm_resource_group.this.location

  application_gateway_name = "app-gw-testing"

  network_interfaces = { for name, nic in azurerm_network_interface.this : name => nic }


  sku = {

    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration = {

    name      = "gw-ip-config-name"
    subnet_id = data.azurerm_subnet.frontend_subnet.id

  }

  frontend_port = {

    "80" = {
      name = "dev-1"
      port = 80

    }
  }

  frontend_ip_configuration = {
    name                            = "my-frontend-ip-config-name"
    public_ip_address_id            = azurerm_public_ip.this.id
    private_ip_address              = null
    private_ip_address_allocation   = null
    private_link_configuration_name = null
  }

  backend_address_pool_names = var.backend_address_pool_names

  # app_gw_rules = {

  #   pool1 = {
  #     name                           = "rule1"
  #     frontend_ip_configuration_name = "my-frontend-ip-config-name"
  #     frontend_port                  = 80
  #     backend_port                   = 80
  #     protocol                       = "Tcp"
  #   }
  # }

  backend_http_settings = {

    "backend_http_settings_1" = {
      name                                = "web-backend-http"
      cookie_based_affinity               = "Disabled"
      affinity_cookie_name                = null
      path                                = "/"
      port                                = 80
      probe_name                          = null
      protocol                            = "Http"
      request_timeout                     = null
      host_name                           = "example.azurewebsites.net"
      pick_host_name_from_backend_address = null
      authentication_certificate          = null

    }

  }

  http_listener = {

    "http_listener-1" = {
      name                           = "web-listener"
      host_name                      = ["*"]
      require_sni                    = false
      ssl_certificate_name           = null
      firewall_policy_id             = null
      ssl_profile_name               = null
      protocol                       = "Http"
      frontend_ip_configuration_name = "my-frontend-ip-config-name"
      frontend_port_name             = "dev-1"

    }

  }

  request_routing_rule = {

    "request_routing_rule_1" = {
      name                        = "web-request"
      priority                    = 9
      rule_type                   = "Basic"
      http_listener_name          = "web-listener"
      backend_address_pool_name   = "pool1"
      backend_http_settings_name  = "web-backend-http"
      redirect_configuration_name = null
      rewrite_rule_set_name       = null
      url_path_map_name           = null

    }

  }

}











