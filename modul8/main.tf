
terraform {
  required_version = ">= 1.16.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  name_prefix = "${var.student_id}-${var.project}"
  rg_name     = "${local.name_prefix}-rg"
}

# Oppretter ressursgruppen
resource "azurerm_resource_group" "main" {
  name     = local.rg_name
  location = var.location
}

# Kaller på den gjenbrukbare nettverksmodulen
module "network" {
  source = "git::https://github.com/joakimboe-tisip/Terraform--vinng-TISIP.git//modules/network?ref=network-v1.1.0"

  project             = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}
