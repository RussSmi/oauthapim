locals {
  key_vault_name = "kvoauthdemo${lower(var.environment)}"
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "keyvault" {
  resource_group_name = "${var.resource_group_name}-apim-${lower(var.environment)}"
  location            = var.location
  name                = local.key_vault_name
  tags                = var.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id


  enable_rbac_authorization       = false
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = false
  sku_name                        = "standard"

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  timeouts {}
}