terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
      version = "2.48.0"
    }
  }
}

provider "azuread" {
  # Configuration options
   tenant_id = var.tenant_id
}