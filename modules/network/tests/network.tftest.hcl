
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
    condition = contains(azurerm_virtual_network.main.address_space, "10.0.0.0/16")
    error_message = "Nettverket har feil adresseområde."
  }
}

run "hovedsubnett" {
  command = plan

  assert {
    condition     = azurerm_subnet.main.address_prefixes == tolist(["10.0.1.0/24"])
    error_message = "Hovedsubnettet har feil adresseområde."
  }
}

run "datasubnett" {
  command = plan

  assert {
    condition     = azurerm_subnet.data.address_prefixes == tolist(["10.0.2.0/24"])
    error_message = "Datasubnettet har feil adresseområde."
  }
}
