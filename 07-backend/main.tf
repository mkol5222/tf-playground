
terraform {

  # https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
  backend "azurerm" {
    resource_group_name  = "somename-tfstate"
    storage_account_name = "tfstate6547"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.64.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

