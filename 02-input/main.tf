
# https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence
variable "name" {
    type = string
    default = "Earth"
}

output "greeting" {
    value = "Hello ${var.name}"
}

# https://github.com/settings/codespaces
variable "PERSON" {
  type = string
  description = "variable defined as GH user codespace secret TF_VAR_PERSON"
}

# http://github.com/mkol5222/tf-playground/settings/secrets/codespaces
variable "TEAM" {
  type = string
  description = "variable defined as GH repo codespace secret TF_VAR_TEAM"
}

output "person-secret" {
  value = "person secret is ${var.PERSON}"
}

output "team-secret" {
  value = "team secret is ${var.TEAM}"
} 