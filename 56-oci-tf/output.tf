
output "vm_ip_address" {
  value = oci_core_instance.vm.public_ip
  
}