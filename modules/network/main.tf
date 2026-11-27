
# Oppretter det virtuelle nettverket
resource "azurerm_virtual_network" "main" {
  name                = "${var.project}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

# Oppretter subnettet i nettverket
resource "azurerm_subnet" "main" {
  name                 = "${var.project}-subnett"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Oppretter data-subnettet
resource "azurerm_subnet" "data" {
  name                 = "${var.project}-data-subnett"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Sikkerhetsgruppe for nettverket
resource "azurerm_network_security_group" "main" {
  name                = "${var.project}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Tillater SSH bare fra angitt nettverk
  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_source_prefix
    destination_address_prefix = "*"
  }
}

# Knytter sikkerhetsgruppen til hovedsubnettet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}
