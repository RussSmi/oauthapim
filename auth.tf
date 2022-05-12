data "azuread_client_config" "current" {}

resource "azuread_application" "oauthapim" {
  display_name = "oathapim-demo"
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph, from az ad sp list --display-name "Microsoft Graph" --query '[].{appDisplayName:appDisplayName, appId:appId}'

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" #todo: this was a default, check if static or should be queried for
      type = "Scope"
    }
  }

  api {
    requested_access_token_version = 2
    oauth2_permission_scope {
      admin_consent_description  = "Allows users to read product details"
      admin_consent_display_name = "Read Products"
      enabled                    = true
      id                         = "29733d9e-a10e-491d-9f33-1d57873e09ac" #todo change this to random_uuid call
      type                       = "User"
      user_consent_description   = "Allows the app to read your products"
      user_consent_display_name  = "Read your products"
      value                      = "Products.Read"
    }
  }
  identifier_uris = [
    "api://2df27e5a-89fa-4ff2-9606-8a13d080b112", #this is actually the generated client id but we can use our own
  ]

  app_role {
        allowed_member_types = [
            "Application",
        ]
        description          = "Readers can read product data"
        display_name         = "Product.Read"
        enabled              = true
       id                   = "a87c9e59-4090-4705-be08-0e0e246f5dfb"  #todo change this to random_uuid call 
        value                = "Product.Read"
    }
}

resource "azuread_application" "oauthapimclient" {
  display_name                   = "oauthapim-demo-client"
  owners       = [data.azuread_client_config.current.object_id]

  api {
    requested_access_token_version = 2
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph, from az ad sp list --display-name "Microsoft Graph" --query '[].{appDisplayName:appDisplayName, appId:appId}'

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" #todo: this was a default, check if static or should be queried for
      type = "Scope"
    }
  }
  required_resource_access {
        resource_app_id = azuread_application.oauthapim.application_id

        resource_access {
            id   = "29733d9e-a10e-491d-9f33-1d57873e09ac"
            type = "Scope"
        }
    }
}