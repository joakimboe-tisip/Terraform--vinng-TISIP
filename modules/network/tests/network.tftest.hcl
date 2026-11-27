
mock_provider "azurerm" {}

variables {
  project             = "kobbnesvik-test"
  location            = "norwayeast"
  resource_group_name = "kobbnesvik-test-rg"
}

run "nettverksnavn" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.main.name == "kobbnesvik-test-vnet"
    error_message = "Nettverket har feil navn."
  }
}

run "nettverksadresse" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.main.address_space == tolist(["10.0.0.0/16"])
    error_message = "Nettverket har feil adresseområde."
  }
}
