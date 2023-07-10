
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.64.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}