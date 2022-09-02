resource "azurerm_bastion_host" "azure_bastion_instance" {
  name                = var.bastion_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                 = "bastion_ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

variable "bastion_name" {
  type        = string
  description = "Bastion name"
}