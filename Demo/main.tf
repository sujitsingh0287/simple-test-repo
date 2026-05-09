resource "azurerm_resource_group" "RG1" {
  name     = var.rg_name
  location = "East US"
}



resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  address_space       = ["10.0.0.0/16"]


}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.RG1.name
  address_prefixes     = ["10.0.1.0/24"]


}

resource "azurerm_public_ip" "pip" {
  name = "dockerpip"
  resource_group_name = azurerm_resource_group.RG1.name
  location = azurerm_resource_group.RG1.location
  allocation_method = "Static"
  
}

resource "azurerm_network_interface" "nic" {
  name                = "delhiprd-nic"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id

  }

}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  size                = "Standard_B2s"
  admin_username      = "dockeruser01"
  admin_password      = "Dockerroot05"
  disable_password_authentication = "false"

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }

source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts-gen2"
  version   = "latest"
}
  }








