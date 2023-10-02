
# az group create --location WestEurope -n tf-playground
data "azurerm_resource_group" "playground" {
  name = "ODL-ccvsa-1112866-02"
}

output "id" {
  value = data.azurerm_resource_group.playground.id
}