resource "random_integer" "example" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "example" {
  name     = local.rg_name
  location = local.location
}