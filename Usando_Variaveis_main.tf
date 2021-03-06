provider "azurerm" {
  features {

  }
}

#aqui em "grupo-recurso" é apenas um alias, preste atenção.
resource "azurerm_resource_group" "grupo-recurso" {

  name     = var.namerg
  location = var.location
  #Adicionando um terceiro valor usando merge
  tags = merge(var.tags, { Treinamento = "Terraform no azure" })
}
#Criando uma vm aqui com rede.

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.grupo-recurso.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.grupo-recurso.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "puc-public-ip" {
  name                = "${var.prefix}-public"
  location            = var.location
  resource_group_name = azurerm_resource_group.grupo-recurso.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "PosGraduacao"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.grupo-recurso.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.puc-public-ip.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.grupo-recurso.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "meudisco"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm-puc"
    admin_username = "puc"
    admin_password = "P@$$w0rd1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "PosGraduacao"
  }
}
