resource "checkpoint_management_data_center_query" "allVMs" {

  name         = "VMs in Azure"
  data_centers = ["All"]
  query_rules {
    key_type = "predefined"
    key      = "type-in-data-center"
    values   = ["Virtual Machine"]
  }
}

resource "checkpoint_management_data_center_query" "appLinux1" {

  name         = "app=linux1"
  data_centers = [checkpoint_management_azure_data_center_server.azureDC.name]
  query_rules {
    key_type = "predefined"
    key      = "type-in-data-center"
    values   = ["Virtual Machine"]
  }
  query_rules {
    key_type = "tag"
    key      = "app"
    values   = ["linux1"]
  }
}