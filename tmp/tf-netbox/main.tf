terraform {
  required_providers {
    netbox = {
      source = "e-breuninger/netbox"
      version = "3.7.6"
    }
  }
}

provider "netbox" {
      server_url = "http://localhost:8000"
  api_token  = "d4c70c4dd38aa779a2f7b6783f18678b11589fee"
}

resource "netbox_ip_address" "this" {
  ip_address = "10.0.0.50/32"
  status     = "reserved"
}

resource "netbox_ip_range" "cust_a_prod" {
  start_address = "10.0.0.1/24"
  end_address   = "10.0.0.50/24"
  tags          = ["customer-a", "prod"]
}