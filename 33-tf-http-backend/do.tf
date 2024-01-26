
terraform {
  backend "http" {
    address = "http://localhost:8000/tfstate/one"
    lock_address = "http://localhost:8000/tfstate/one"
    unlock_address ="http://localhost:8000/tfstate/one"
  }
}

output "greeting" {
    value = "Hello world! at ${timestamp()}"
}