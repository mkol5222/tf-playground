
resource "azurerm_kubernetes_cluster" "aks" {

  name                = var.aks_name
  #kubernetes_version  = "1.28"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_name
  node_resource_group = "${var.resource_group_name}-${var.aks_name}-nodes"

  default_node_pool {

    name       = "system"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
    type       = "VirtualMachineScaleSets"
    #availability_zones  = [1, 2, 3]
    enable_auto_scaling = false
    vnet_subnet_id      = var.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    # load_balancer_sku = "Standard"
    network_plugin = "azure" # azure (CNI)
    network_policy = "azure"

  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}

