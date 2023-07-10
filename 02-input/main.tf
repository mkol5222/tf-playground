variable "name" {
    type = string
    default = "Earth"
}

output "greeting" {
    value = "Hello ${var.name}"
}
  