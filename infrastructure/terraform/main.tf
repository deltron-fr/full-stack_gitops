# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_name
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_name}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.address_space
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes
}

# Create Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.resource_name}-public_ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Dynamic"
}

# Create nic
resource "azurerm_network_interface" "nic" {
  name                = "${var.resource_name}-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  ip_configuration {
    name                          = "${var.resource_name}-nic-configuration"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Create Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg_nic_connection" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# Create Network Sceurity Rules
resource "azurerm_network_security_rule" "Allow_SSH" {
  resource_group_name         = var.resource_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  name                        = "SSH"
  priority                    = 1001
  destination_port_range      = "22"
  source_port_range           = "*"
  direction                   = "Inbound"
  access                      = "Allow"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  protocol                    = "Tcp"
}

resource "azurerm_network_security_rule" "Allow_HTTP" {
  resource_group_name         = var.resource_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  name                        = "HTTP"
  priority                    = 1002
  destination_port_range      = "80"
  source_port_range           = "*"
  direction                   = "Inbound"
  access                      = "Allow"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  protocol                    = "Tcp"
}

resource "azurerm_network_security_rule" "Allow_HTTPS" {
  resource_group_name         = var.resource_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  name                        = "HTTPS"
  priority                    = 1003
  destination_port_range      = "443"
  source_port_range           = "*"
  direction                   = "Inbound"
  access                      = "Allow"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  protocol                    = "Tcp"
}


# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.resource_name}vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.nic.id]
  computer_name         = "azurevm"

  os_disk {
    name                 = "MyOSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_key_path)
  }
}



