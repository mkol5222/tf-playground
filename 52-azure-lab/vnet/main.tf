resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name          = "${var.resource_group_name}-vnet"
  address_space = ["10.68.0.0/16"]

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

resource "azurerm_subnet" "cpman_subnet" {
    name                 = "${var.resource_group_name}-cpman-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.68.107.0/24"]  
}


resource "azurerm_subnet" "frontend" {
    name                 = "frontend"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.68.201.0/24"]  
}

resource "azurerm_subnet" "backend" {
    name                 = "backend"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.68.202.0/24"]  
}

# resource "azurerm_subnet" "aks-subnet" {
#     name                 = "${var.resource_group_name}-aks-subnet"
#     resource_group_name  = azurerm_resource_group.rg.name
#     virtual_network_name = azurerm_virtual_network.vnet.name
#     address_prefixes     = ["10.68.1.0/24"]  
# }

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "aks-subnet" {
    name                 = "${var.resource_group_name}-aks-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.68.1.0/24"]  
}
