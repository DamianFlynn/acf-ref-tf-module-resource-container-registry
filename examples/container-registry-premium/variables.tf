variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Optional) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. Defaults to 'p-we1cr-acr'"
  type        = string
  default     = "p-we1cr-acr"
}

variable "location" {
  description = "(Optional) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Defaults to West Europe"
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}


variable "georeplication_locations" {
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated. Defaults to no replications"
  type        = list(string)
  default     = []
}
