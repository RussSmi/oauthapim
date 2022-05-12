locals {
  apim_product_op_policy_path = format("%s%s", var.apim_policies_path, "op_getproduct_policy.xml")
}

data "azurerm_api_management" "apim" {
  name                = "apim-ais-demo-${lower(var.environment)}"
  resource_group_name = "${var.resource_group_name}-apim-${lower(var.environment)}"
}

resource "azurerm_api_management_api" "apim" {
  display_name        = "Products"
  name                = "products"
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
  path                = "products"
  revision            = "1"
  service_url         = var.api-url
  soap_pass_through   = false

  protocols = [
    "https",
  ]

  subscription_key_parameter_names {
    header = "Ocp-Apim-Subscription-Key"
    query  = "subscription-key"
  }
}

resource "azurerm_api_management_api_operation" "apim-post" {
  api_name            = azurerm_api_management_api.apim.name
  api_management_name = azurerm_api_management_api.apim.api_management_name
  resource_group_name = azurerm_api_management_api.apim.resource_group_name
  display_name        = "GetProduct"
  method              = "GET"
  operation_id        = "GetProduct"
  url_template        = "/GetProduct"

  request {
    query_parameter {
      description = "Product Id"
      name        = "productid"
      required    = true
      type        = "string"
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "apim-post" {
  api_name            = azurerm_api_management_api_operation.apim-post.api_name
  api_management_name = azurerm_api_management_api_operation.apim-post.api_management_name
  resource_group_name = azurerm_api_management_api_operation.apim-post.resource_group_name
  operation_id        = azurerm_api_management_api_operation.apim-post.operation_id


  xml_content = replace(file(local.apim_product_op_policy_path), "{backend-app-client-id}", "${azuread_application.oauthapim.application_id}")

}