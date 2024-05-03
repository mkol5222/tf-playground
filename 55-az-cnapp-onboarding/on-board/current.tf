data "azurerm_subscription" "current" {
}

locals {
  // subscription_list = [data.azurerm_subscription.current.subscription_id]
  subscription_list = ["f4ad5e85-ec75-4321-8854-ed7eb611f61d"]
}

data "azurerm_subscription" "list" {
  for_each = { for sub in local.subscription_list : sub => sub }
  subscription_id       = each.value
}

locals {
  subscriptions = {
    for sub in local.subscription_list :
    sub => data.azurerm_subscription.list[sub]
  }
}


# Creating the Azure environments on CloduGuard
resource "dome9_cloudaccount_azure" "connect-azure-subscription" {

  for_each = local.subscriptions

  operation_mode  = "Read"
  tenant_id       = var.azure-tenant
  client_id       = var.azure-client-id
  client_password = var.azure-client-secret
  name            = each.value.display_name
  subscription_id = each.key
}