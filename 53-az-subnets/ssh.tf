resource "tls_private_key" "linux_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


locals {
  ssh_configs = ""
}

output "ssh_configs" {
    value = local.ssh_configs
}