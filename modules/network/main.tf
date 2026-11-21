
# Oppretter det virtuelle nettverket
resource "azurerm_virtual_network" "main" {
  name                = "${var.project}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

# Oppretter subnettet i nettverket
resource "azurerm_subnet" "main" {
  name                 = "${var.project}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_subnet" "data" {
  name                 = "${var.project}-data-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
