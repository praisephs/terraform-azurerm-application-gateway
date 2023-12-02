output "app_gateway_out" {
  value = azurerm_application_gateway.this.backend_address_pool

}

output "network_interface_debug" {
  value = var.network_interfaces
}

