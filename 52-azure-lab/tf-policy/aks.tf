
locals {
  aks_creds = jsondecode(file("${path.module}/sa.json"))
}

resource "checkpoint_management_kubernetes_data_center_server" "aks" {
  name               = "AKS"
  hostname           = local.aks_creds.api
  token_file         = base64encode(local.aks_creds.token)
  ca_certificate     = base64encode(local.aks_creds.k8s_cluster_ca_certificate)
  ignore_warnings    = true
  unsafe_auto_accept = true
}