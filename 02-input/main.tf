variable "name" {
    type = string
    default = "Earth"
}

output "greeting" {
    value = "Hello ${var.name}"
}

variable "person" {
  type = string
  description = "variable defined as GH user codespace secret TF_VAR_person"
}

variable "team" {
  type = string
  description = "variable defined as GH repo codespace secret TF_VAR_team"
}

output "person-secret" {
  value = "person secret is ${var.person}"
}

output "team-secret" {
  value = "team secret is ${var.team}"
} 