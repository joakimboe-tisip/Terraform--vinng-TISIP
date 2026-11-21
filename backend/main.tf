terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }
  }
}

provider "azurerm" {
  features {}

  resource_providers_to_register = [
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "backend" {
  name     = "rg-backend-${var.student_id}"
  location = var.location

  tags = {
    keep = "true"
  }
}

resource "azurerm_storage_account" "backend" {
  name                     = "stdemo${var.student_id}"
  resource_group_name      = azurerm_resource_group.backend.name
  location                 = azurerm_resource_group.backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }
  }

  tags = {
    keep = "true"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.backend.id
  container_access_type = "private"
}

resource "azurerm_key_vault" "backend" {
  name                       = "kv-backend-${var.student_id}"
  location                   = azurerm_resource_group.backend.location
  resource_group_name        = azurerm_resource_group.backend.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = {
    keep = "true"
  }
}

# Brukeren som kjører Terraform
resource "azurerm_role_assignment" "user_rg" {
  scope                = azurerm_resource_group.backend.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "user_storage" {
  scope                = azurerm_storage_account.backend.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "user_keyvault" {
  scope                = azurerm_key_vault.backend.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# GitHub Actions-pipelinen
resource "azurerm_role_assignment" "pipeline_rg" {
  scope                = azurerm_resource_group.backend.id
  role_definition_name = "Contributor"
  principal_id         = var.pipeline_principal_id
}

resource "azurerm_role_assignment" "pipeline_storage" {
  scope                = azurerm_storage_account.backend.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.pipeline_principal_id
}

resource "azurerm_role_assignment" "pipeline_keyvault" {
  scope                = azurerm_key_vault.backend.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.pipeline_principal_id
}