resource "azurerm_windows_virtual_machine" "jump_host" {
  name                = var.host_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.host_sku
  admin_username      = var.host_username
  admin_password      = var.host_password
  network_interface_ids = [
    azurerm_network_interface.jump_host.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-ent"
    version   = "latest"
  }
}