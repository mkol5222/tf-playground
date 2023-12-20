
output "kubeconfig" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "kubeconfig_data" {
  value = azurerm_kubernetes_cluster.aks.kube_config
  sensitive = true
}