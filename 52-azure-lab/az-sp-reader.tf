
module "reader" {
  source = "./reader"

  subscription_id = var.subscription_id
  
 tenant_id = var.tenant_id
}

output "reader_client_id" {
  value = module.reader.client_id
}

output "reader_client_secret" {
  sensitive = true
  value     = module.reader.client_secret
}
