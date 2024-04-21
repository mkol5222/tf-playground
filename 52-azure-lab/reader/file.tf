locals {
    reader_creds = jsonencode(
        {
            tenant_id: var.tenant_id,
            subscription_id: var.subscription_id,
            client_id: azuread_application.cgns-reader.application_id,
            client_secret: azuread_application_password.cgns-reader-key.value
        }
    )
}

resource "local_file" "reader_creds" {

  content  = local.reader_creds
  filename = "${path.module}/../tf-policy/reader.json"
}

output "file" {
    value = "${path.module}/../tf-policy/reader.json"
}