module "aks" {
    source = "./aks"
}

output "kubeconfig" {
  value = module.aks.kubeconfig
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
   features {}
}