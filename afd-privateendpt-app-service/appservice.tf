resource "azurerm_service_plan" "example" {
  name                = local.serviceplan_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_name            = var.webapp_sku
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "example" {
  name                = local.webapp_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {
  }
}

resource "azurerm_private_endpoint" "example" {
  name                = "appservice-endpoint"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.appservice.id
    ]
  }

  private_service_connection {
    name                           = "appservice-privateserviceconnection"
    private_connection_resource_id = azurerm_windows_web_app.example.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}


