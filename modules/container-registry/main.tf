terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.acr]
    }
  }

  required_version = ">= 1.1.3"
}

# provider "azurerm" {
#   features {}
#   alias = "acr"
# }

locals {
  module_tag = {
    "module_name"    = basename(abspath(path.module))
    "module_version" = "-.-.-"
  }
  tags = merge(var.tags, local.module_tag)
}




resource "azurerm_container_registry" "acr" {
  name = join("", regexall("[[:alnum:]]+", var.name))
  # provider                 = azurerm.acr
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
  sku                 = var.sku

  admin_enabled = var.admin_enabled

  dynamic "network_rule_set" {
    for_each = toset(var.sku == "Premium" ? ["fake"] : [])

    content {
      default_action = "Deny"
    }
  }

  quarantine_policy_enabled = false
  trust_policy {
    enabled = var.sku == "Premium" ? true : false
  }

  retention_policy {
    enabled = var.sku == "Premium" ? true : false
    days    = 15
  }

  public_network_access_enabled = var.sku == "Premium" ? false : true

  # encryption {
  #   enabled = false
  # }

  data_endpoint_enabled      = var.sku == "Premium" ? true : false
  network_rule_bypass_option = "AzureServices"
  zone_redundancy_enabled    = false

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.acr_identity.id
    ]
  }

  dynamic "georeplications" {
    for_each = var.georeplication_locations

    content {
      location = georeplications.value
      tags     = local.tags
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_user_assigned_identity" "acr_identity" {
  # provider            = azurerm.acr
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags

  name = "${var.name}-identity"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  count = var.log_analytics_workspace_id == null ? 0 : 1
  name  = "DiagnosticsSettings"
  # provider                   = azurerm.acr
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "ContainerRegistryRepositoryEvents"
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.log_analytics_retention_days
    }
  }

  log {
    category = "ContainerRegistryLoginEvents"
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.log_analytics_retention_days
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = var.log_analytics_retention_days
    }
  }
}
