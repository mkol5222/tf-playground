terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.100.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-nsoiss"
    storage_account_name = "chpktfstatestoragensoiss"
    container_name       = "tfstatecontainer"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}
