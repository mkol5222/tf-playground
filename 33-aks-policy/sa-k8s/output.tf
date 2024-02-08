output "sa_token" {
    sensitive = true
    value = kubernetes_secret.cloudguard_controller.data.token
}