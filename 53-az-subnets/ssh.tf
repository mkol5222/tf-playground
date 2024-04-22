resource "tls_private_key" "linux_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "ssh_key" {
    sensitive = true
    value = tls_private_key.linux_ssh.private_key_openssh
}

output "ssh_key_pub" {
    value = tls_private_key.linux_ssh.public_key_openssh
}

locals {
  ssh_configs = ""
}

output "ssh_configs" {
    value = local.ssh_configs
}