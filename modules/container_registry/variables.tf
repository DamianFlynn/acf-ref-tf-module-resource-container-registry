variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}

variable "admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  type        = string
  default     = false
}

variable "sku" {
  description = "(Optional) The SKU name of the container registry. Possible values are Basic, Standard and Premium. Defaults to Basic"
  type        = string
  default     = "Basic"

  validation {
    condition = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The container registry sku is invalid."
  }
}


variable "georeplication_locations" {
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated. Defaults to no replications"
  type        = list(string)
  default     = []
}


variable "log_analytics_workspace_id" {
  description = "(Optional) Specify a log analytics workspace to connect with the container registry"
  type        = string
  default = null
}

variable "log_analytics_retention_days" {
  description = "Specifies the number of days of the retention policy, defaults to 7"
  type        = number
  default     = 7
}