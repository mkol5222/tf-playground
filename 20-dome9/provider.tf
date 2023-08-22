
terraform {
  required_providers {
    dome9 = {
      source = "dome9/dome9"
      version = "1.29.5"
    }
  }
}

provider "dome9" {
  dome9_access_id     = "${var.D9CLIENT}"
  dome9_secret_key    = "${var.D9SECRET}"
   base_url            = "https://api.eu1.dome9.com/v2/"
}

variable "D9CLIENT" {
  type = string
  description = "CNAPP access ID"
}

variable "D9SECRET" {
    type = string
    description = "value of CNAPP secret key"
  
}