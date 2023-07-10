terraform {
  required_version = ">= 1.1.0"
  required_providers {

    inext = {
      source  = "CheckPointSW/infinity-next"
      version = "~> 1.0.3"
    }
  }
}


provider "inext" {
  region     = "eu"
  client_id  = var.appsec-client-id
  access_key = var.appsec-client-secret
}