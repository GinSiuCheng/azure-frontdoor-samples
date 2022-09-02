resource "azurerm_cdn_frontdoor_profile" "example" {
  name                = local.afd_profile_name
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = var.afd_sku
}

resource "azurerm_cdn_frontdoor_endpoint" "example" {
  name                     = local.afd_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
}

resource "azurerm_cdn_frontdoor_origin_group" "example" {
  name                     = local.afd_origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id

  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}


resource "azurerm_cdn_frontdoor_origin" "example" {
  name                          = local.afd_origin_name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example.id

  health_probes_enabled          = true
  certificate_name_check_enabled = true
  host_name                      = azurerm_windows_web_app.example.default_hostname
  origin_host_header             = azurerm_windows_web_app.example.default_hostname
  priority                       = 1
  weight                         = 500

  private_link {
    request_message        = "Request access for Private Link Origin CDN Frontdoor"
    target_type            = "sites"
    location               = azurerm_windows_web_app.example.location
    private_link_target_id = azurerm_windows_web_app.example.id
  }
}

resource "azapi_resource" "route" {
  name      = local.afd_app_route_name
  type      = "Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01"
  parent_id = azurerm_cdn_frontdoor_endpoint.example.id
  body = jsonencode({
    properties = {
      originGroup = {
        id = azurerm_cdn_frontdoor_origin_group.example.id
      }
      supportedProtocols = [
        "Http",
        "Https"
      ]
      patternsToMatch = [
        "/*"
      ]
      cacheConfiguration = {
        queryStringCachingBehavior = "IgnoreQueryString"
      }
      forwardingProtocol  = "MatchRequest"
      linkToDefaultDomain = "Enabled"
      httpsRedirect       = "Enabled"
    }
  })
  depends_on = [
    azurerm_cdn_frontdoor_origin.example
  ]
}