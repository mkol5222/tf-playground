
// inspiration at https://github.com/stealthybox/tf-oci-arm

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  #config_file_profile= var.config_file_profile
  user_ocid            = var.user_ocid
  private_key_path     = var.private_key_path
  #private_key_password = var.private_key_password
  region               = var.region
  fingerprint = var.fingerprint
}


