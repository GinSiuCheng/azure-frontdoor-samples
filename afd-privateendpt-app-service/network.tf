# Virtual network 
resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = var.vnet_address_space
}

# Subnets
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.bastion_subnet_address_prefixes
}

resource "azurerm_subnet" "private_endpoints" {
  name                                           = "private-endpoint-subnet"
  resource_group_name                            = azurerm_resource_group.example.name
  virtual_network_name                           = azurerm_virtual_network.example.name
  address_prefixes                               = var.private_endpoint_subnet_address_prefixes
  enforce_private_link_endpoint_network_policies = true
}


resource "azurerm_subnet" "host" {
  name                 = "host-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.host_subnet_address_prefixes
}

# IP 
resource "azurerm_public_ip" "bastion" {
  name                = "azure_bastion_ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NIC
resource "azurerm_network_interface" "jump_host" {
  name                = "host-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal-host"
    subnet_id                     = azurerm_subnet.host.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.6"
  }
}

# DNS
resource "azurerm_private_dns_zone" "appservice" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "appservice-dns-link"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.appservice.name
  virtual_network_id    = azurerm_virtual_network.example.id
}