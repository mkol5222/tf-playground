resource "random_string" "uniq" {
  length = 6
  lower  = true
  numeric = true
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${random_string.uniq.result}"
  location = var.location
}

data "azurerm_client_config" "current" {}

output "client_object_id" {
    value = data.azurerm_client_config.current.object_id
}

data external account_info {
  program                      = [
                                 "az",
                                 "ad",
                                 "signed-in-user",
                                 "show",
                                 "--query",
                                 "{object_id:id}",
                                 "-o",
                                 "json",
                                 ]
}

output user_object_id {
    value = data.external.account_info.result.object_id
}

output "keyvault_name" {
  value = azurerm_key_vault.keyvault.name  
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.keyvault_name}${random_string.uniq.result}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  #soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.external.account_info.result.object_id # data.azurerm_client_config.current.client_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
      "list",
      "set",
      "delete"
    ]

    storage_permissions = [
      "get",
    ]
  }

  # network_acls {
  #   default_action = "Deny" # "Allow" 
  #   bypass         = "AzureServices" # "None"
  #   ip_rules = ["50.50.50.50/24"]
  # }
}

resource "azurerm_key_vault_secret" "db-pwd" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.keyvault.id
}

# resource "azurerm_key_vault_access_policy" "policy" {
#   key_vault_id = azurerm_key_vault.keyvault.id
#
#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = "11111111-1111-1111-1111-111111111111" # SPN ID
#
#   key_permissions = [
#     "get",
#   ]
#
#   secret_permissions = [
#     "get",
#   ]
# }