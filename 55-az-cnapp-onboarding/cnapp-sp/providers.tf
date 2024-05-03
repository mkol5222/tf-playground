
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
    }

  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  client_id                  = var.azure-client-id
  client_secret              = var.azure-client-secret
  subscription_id            = var.azure-subscription
  tenant_id                  = var.azure-tenant
}

