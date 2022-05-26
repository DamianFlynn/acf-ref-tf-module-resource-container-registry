output "container_registry_id" {
  value = module.container_registry.id
  description = "Specifies the resource id of the container registry"
}

output "container_registry_login_url" {
  value = module.container_registry.login_server_url
  description = "The URL for accessing the container registry"
}