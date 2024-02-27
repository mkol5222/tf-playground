
resource "azurerm_resource_group" "rg" {
  name = "${var.project_prefix}-rg"
  location = var.location
}



resource "azurerm_virtual_network" "vnet" {
  name          = "${var.project_prefix}-vnet"
  address_space = ["10.247.0.0/16"]

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

    lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

resource "azurerm_subnet" "cp-front-subnet" {
    name                 = "${var.project_prefix}-cp-front-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.247.136.0/28"]  
}

resource "azurerm_subnet" "cp-back-subnet" {
    name                 = "${var.project_prefix}-cp-back-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.247.136.16/28"]  
}

output "vnet_rg" {
  value = azurerm_resource_group.rg
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "cp-front-subnet" {
  value = azurerm_subnet.cp-front-subnet
}

output "cp-back-subnet" {
  value = azurerm_subnet.cp-back-subnet
}