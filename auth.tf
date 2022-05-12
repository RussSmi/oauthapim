data "azuread_client_config" "current" {}

resource "random_uuid" "graphaccess"{}
resource "random_uuid" "oauthapimapi"{}
resource "random_uuid" "oauthapirole"{}

resource "azuread_application" "oauthapim" {
  display_name = "oathapim-demo"
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = var.msgraphid
    resource_access {
      id   = random_uuid.graphaccess.id
      type = "Scope"
    }
  }

  api {
    requested_access_token_version = 2
    oauth2_permission_scope {
      admin_consent_description  = "Allows users to read product details"
      admin_consent_display_name = "Read Products"
      enabled                    = true
      id                         = random_uuid.oauthapimapi.id
      type                       = "User"
      user_consent_description   = "Allows the app to read your products"
      user_consent_display_name  = "Read your products"
      value                      = "Products.Read"
    }
  }
  identifier_uris = [
    "api://${var.app_reg_app_id_uri}", #this is actually the generated client id but we can use our own
  ]

  app_role {
    allowed_member_types = [
      "Application",
    ]
    description  = "Readers can read product data"
    display_name = "Product.Read"
    enabled      = true
    id           = random_uuid.oauthapirole.id
    value        = "Product.Read"
  }
}

resource "azuread_application" "oauthapimclient" {
  display_name = "oauthapim-demo-client"
  owners       = [data.azuread_client_config.current.object_id]

  api {
    requested_access_token_version = 2
  }

  required_resource_access {
    resource_app_id = var.msgraphid

    resource_access {
      id   = random_uuid.graphaccess.id
      type = "Scope"
    }
  }
  required_resource_access {
    resource_app_id = azuread_application.oauthapim.application_id

    resource_access {
      id   = random_uuid.oauthapimapi.id #the api id of the app reg above
      type = "Scope"
    }
  }
}

resource "azuread_application_password" "clientsecret" {
  application_object_id = azuread_application.oauthapimclient.object_id
}

data "azurerm_key_vault" "kv" {
  name                = local.key_vault_name
  resource_group_name = local.apim_rg_name

  depends_on = [
    azurerm_key_vault.keyvault
  ]
}

resource "azurerm_key_vault_access_policy" "kv" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
  ]

  depends_on = [
    data.azurerm_key_vault.kv
  ]
}

resource "azurerm_key_vault_secret" "clientsecret" {
  name         = "oauth-client-app-secret"
  value        = azuread_application_password.clientsecret.value
  key_vault_id = data.azurerm_key_vault.kv.id

  depends_on = [
    azurerm_key_vault_access_policy.kv
  ]
}