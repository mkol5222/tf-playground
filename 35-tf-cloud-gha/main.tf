terraform {
  cloud {
    organization = "cp-cnc"

    workspaces {
      name = "demo1"
    }
  }
}

output "ts" {
  value = "ts is ${timestamp()}"

}

resource "null_resource" "some" {
 
  triggers = {
    time = timestamp()
  }
}