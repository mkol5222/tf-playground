
output "client_id" {
    value = azuread_application.cgns-reader.application_id
}

output "client_secret" {
    value = azuread_application_password.cgns-reader-key.value
}

