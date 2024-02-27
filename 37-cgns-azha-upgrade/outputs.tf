output "linux_key" {
  value     = module.linux.ssh_key
  sensitive = true
}

output "linux_ssh_config" {
  value = module.linux.ssh_config
}