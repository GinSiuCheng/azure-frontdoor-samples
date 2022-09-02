locals {
  rg_name  = "${var.rg_name}-${random_integer.example.id}-rg"
  location = var.location

  # AFD Locals
  afd_profile_name      = var.afd_profile_name != "" ? var.afd_profile_name : "afd-profile-${random_integer.example.id}"
  afd_endpoint_name     = var.afd_endpoint_name != "" ? var.afd_endpoint_name : "afd-endpoint-${random_integer.example.id}"
  afd_origin_group_name = var.afd_origin_group_name != "" ? var.afd_origin_group_name : "origingroup-${random_integer.example.id}"
  afd_origin_name       = var.afd_origin_name != "" ? var.afd_origin_name : "appservice-${random_integer.example.id}"
  afd_app_route_name    = var.afd_app_route_name != "" ? var.afd_app_route_name : "route-appservice-${random_integer.example.id}"

  # App Service 
  serviceplan_name = var.serviceplan_name != "" ? var.serviceplan_name : "serviceplan-${random_integer.example.id}"
  webapp_name      = var.webapp_name != "" ? var.webapp_name : "webapp-${random_integer.example.id}"

}

