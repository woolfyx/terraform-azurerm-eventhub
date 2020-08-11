variable "eventhub_namespace" {
  description = "Event Hub NameSpace"
  default     = ""
}
variable "location" {
  description = "Azure location where resources should be deployed."
}
variable "region" {
  description = "region reference where resources should be deployed. Valid options are we1, wus1, sea1."
}
variable "environment" {
  description = "Resource deployment environment"
}
variable "shortprojectlabel" {
  description = "Short project technical name - usefull for resources with limited name size"
}
variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}
variable "sku" {
  description = "tier to use : Basic or Standard"
}
variable "capacity" {
  description = "Throughput Units for a Standard SKU namespace"
}
variable "namespace_authorization_rules" {
  description = "List of authorization rules to be created at namespace level. For 'manage' set 'Listen' and 'Send' to 'True' too"
  type = list(object({
    name   = string
    listen = bool
    send   = bool
    manage = bool
  }))
  default = []
}

variable "eventhubs" {
  description = "List of EventHubs to be created. The admitted arguments are :\n- `name`\n- `partition_count`\n- `message_retention`\n- `consumer_groups`: List to create multiple consumer groups for an EventHub\n- `authorization_rules`: List to create authorization rule(s) to be created a the Hub level - For 'manage' set 'Listen' and 'Send' to 'True' too"
  type = list(object({
    name              = string
    partition_count   = number
    message_retention = number
    consumer_groups   = list(string)
    authorization_rules = list(object({
      name   = string
      listen = bool
      send   = bool
      manage = bool
    }))
  }))
  default = []
}