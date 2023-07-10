
# az group create --location WestEurope -n tf-playground
data "azurerm_resource_group" "playground" {
  name = "tf-playground"
}

output "id" {
  value = data.azurerm_resource_group.playground.id
}