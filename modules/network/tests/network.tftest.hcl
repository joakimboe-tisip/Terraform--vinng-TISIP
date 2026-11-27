
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

run "nettverksadresser" {
  command = plan

  assert {
    condition = (
      contains(azurerm_virtual_network.main.address_space, "10.0.0.0/16") &&
      contains(azurerm_subnet.main.address_prefixes, "10.0.1.0/24") &&
      contains(azurerm_subnet.data.address_prefixes, "10.0.2.0/24")
    )
    error_message = "Nettverket eller subnettene har feil adresseområde."
  }
}

run "ugyldig_prosjektnavn" {
  command = plan

  variables {
    project = "UGYLDIG_NAVN"
  }

  expect_failures = [
    var.project
  ]
}

run "ssh_er_ikke_aapent_for_internett" {
  command = plan

  assert {
    condition = (
      one(azurerm_network_security_group.main.security_rule).source_address_prefix == "10.0.0.0/16" &&
      one(azurerm_network_security_group.main.security_rule).destination_port_range == "22"
    )
    error_message = "SSH (port 22) skal bare være tillatt fra det interne nettverket."
  }
}
