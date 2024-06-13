provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "tfstate-${random_string.storage_account_suffix.result}"
  location = "westeurope"
}

resource "random_string" "storage_account_suffix" {
  length  = 6
  special = false
  upper = false
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "chpktfstatestorage${random_string.storage_account_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"


}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstatecontainer"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

    # resource_group_name   = azurerm_resource_group.example.name
    # storage_account_name  = azurerm_storage_account.example.name
    # container_name        = azurerm_storage_container.example.name
    # key                   = "terraform.tfstate"

output "tfstate_rg" {
  value = azurerm_resource_group.rg.name
}

output "tfstate_sa" {
  value = azurerm_storage_account.tfstate.name
}

output "tfstate_container" {
    value = azurerm_storage_container.tfstate.name
}

output "tfstate_key" {
  value = "terraform.tfstate"
}

output "tfstate_vars" {
  value = <<-EOT
  
resource_group_name="${azurerm_resource_group.rg.name}"
storage_account_name="${azurerm_storage_account.tfstate.name}"
container_name="${azurerm_storage_container.tfstate.name}"
key="terraform.tfstate"
EOT
}