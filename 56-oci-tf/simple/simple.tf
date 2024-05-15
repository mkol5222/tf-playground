data "oci_core_images" "amd-ubuntu-images1" {
  compartment_id           = var.oci_compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

output "ubuntu_images_amd" {
  value = data.oci_core_images.amd-ubuntu-images1.images
}

variable "oci_compartment_id" {
  type = string
  description = "compartment id"
}