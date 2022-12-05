module "service_principal" {
  source = "ptonini/service-principal/azuread"
  version = "~> 1.0.0"
  count = var.service_principal == null ? 1 : 0
  name = var.service_principal_name
  create_password = true
  resource_accesses = var.service_principal_resource_accesses
  homepage_url = var.homepage_url
}

module "auth_backend" {
  source = "ptonini/auth-backend/vault"
  version = "~> 1.0.0"
  type = "azure"
  path = var.path
}

resource "vault_azure_auth_backend_config" "example" {
  backend = module.auth_backend.this.path
  tenant_id = var.tenant_id
  client_id = var.service_principal == null ? module.service_principal[0].application.application_id : var.service_principal.client_id
  client_secret = var.service_principal == null ? module.service_principal[0].password : var.service_principal.client_secret
  resource = var.homepage_url
  environment = var.environment
}