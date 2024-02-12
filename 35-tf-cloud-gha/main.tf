terraform {
  cloud {
    organization = "cp-cnc"

    workspaces {
      name = "demo1"
    }
  }
}

output "ts" {
    value = timestamp()
  
}