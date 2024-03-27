terraform {
  required_providers {
    checkpoint = {
      source  = "checkpointsw/checkpoint"
      version = "2.7.0"
    }
  }
}

provider "checkpoint" {
  # Configuration options
  server  = var.CPSERVER
  api_key = var.CPAPIKEY

  context = "web_api"
}
