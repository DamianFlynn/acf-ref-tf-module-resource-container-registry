terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.mgt ]
    }
  }

  required_version = ">= 1.1.3"
}

provider "azurerm" {
  features {}
  # alias           = "p-mgt"
  # subscription_id = var.MGT_SubscriptionId
}


locals {
  module_tag = {
    "example_name"    = basename(abspath(path.module))
    "example_version" = "0.0.1"
  }
  tags = merge(var.tags, local.module_tag)

  log_analytics_solutions = {
    ContainerInsights = {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    }
  }

  solution_plan_map = merge(var.solution_plan_map, local.log_analytics_solutions)
}


# ---------------------------------------------------------------------------------------------------------------------
# CREAT THE RESOURCE GROUP FOR THE LOG ANALYTICS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "p_acr_acr" {
  name = var.resource_group_name
  # provider = azurerm.mgt
  provider = azurerm
  location = var.location
  tags     = local.tags
}

module "container_registry" {
  source = "./modules/container-registry"
  name   = var.name
  tags   = local.tags

  providers = {
    azurerm.acr = azurerm
    # azurerm.mgt = azurerm
  }
  location            = var.location
  resource_group_name = azurerm_resource_group.p_acr_acr.name
}
