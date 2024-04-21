
locals {
  reader_creds = jsondecode(file("${path.module}/reader.json"))
}


resource "checkpoint_management_azure_data_center_server" "azureDC" {
  name                  = "Azure"
  authentication_method = "service-principal-authentication"
  directory_id          = local.reader_creds.tenant_id
  application_id        = local.reader_creds.client_id
  application_key       = local.reader_creds.client_secret

  ignore_warnings = true
}