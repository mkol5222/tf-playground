module "aks" {
  source                 = "./aks"
  myip                   = local.myip
  route_through_firewall = var.route_through_firewall
  //resource_group_name = "rg-demo-aks-jan25"
  vnet   = module.vnet.vnet.name
  rg     = module.vnet.rg.name
  aks_subnet = module.vnet.aks_subnet
}

module "sa" {
  source                     = "./sa-k8s"
  k8s_host                   = module.aks.kubeconfig_data[0]["host"]
  k8s_client_certificate     = base64decode(module.aks.kubeconfig_data[0]["client_certificate"])
  k8s_client_key             = base64decode(module.aks.kubeconfig_data[0]["client_key"])
  k8s_cluster_ca_certificate = base64decode(module.aks.kubeconfig_data[0]["cluster_ca_certificate"])
}

locals {
  aks_creds = {
    api =  module.aks.kubeconfig_data[0]["host"]
    token = module.sa.sa_token
    k8s_cluster_ca_certificate = base64decode(module.aks.kubeconfig_data[0]["cluster_ca_certificate"])
  }
}

output "aks_creds" {
    sensitive = true
    value = jsonencode(local.aks_creds)
}
