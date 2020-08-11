#### NAMESPACE

output "namespace_id" {
  description = "The ID of EventHub Namespace"
  value       = azurerm_eventhub_namespace.namespace.id
}

output "namespace_authorizationrules_primary_key" {
  description = "The primary key for namespace authorization rule"
  sensitive   = true
  value = {
    for rule in azurerm_eventhub_namespace_authorization_rule.namespacerule :
    "${rule.namespace_name}-${rule.name}" => rule.primary_key
  }
}

output "namespace_authorizationrules_primary_connection_string" {
  description = "The primary connection string for namespace authorization rule"
  sensitive   = true
  value = {
    for rule in azurerm_eventhub_namespace_authorization_rule.namespacerule :
    "${rule.namespace_name}-${rule.name}" => rule.primary_connection_string
  }
}

output "namespace_authorizationrules_secondary_key" {
  description = "The secondary key for namespace authorization rule"
  sensitive   = true
  value = {
    for rule in azurerm_eventhub_namespace_authorization_rule.namespacerule :
    "${rule.namespace_name}-${rule.name}" => rule.secondary_key
  }
}

output "namespace_authorizationrules_secondary_connection_string" {
  description = "The secondary connection string for namespace authorization rule"
  sensitive   = true
  value = {
    for rule in azurerm_eventhub_namespace_authorization_rule.namespacerule :
    "${rule.namespace_name}-${rule.name}" => rule.secondary_connection_string
  }
}

### EVENTHUBS

output "eventhubs_id" {
  description = "The ID of EventHubs"
  value       = azurerm_eventhub.eventhub.*.id
}

output "eventhubs_partition_ids" {
  description = "The IDs of EventHubs partition"
  value       = azurerm_eventhub.eventhub.*.partition_ids
}

output "eventhubs_consumergroups_ids_per_eventhub" {
  description = "The IDs of EventHubs consumer groups"
  value = {
    for consumergroup in azurerm_eventhub_consumer_group.consumergroup :
    consumergroup.eventhub_name => consumergroup.id...
  }
}

output "eventhubs_authorizationrules_primary_key" {
  description = "The primary key for EventHubs authorization rule"
  sensitive   = true
  value = {
    for rule in azurerm_eventhub_authorization_rule.eventhubrule :
    "${rule.eventhub_name}-${rule.name}" => rule.primary_key
  }
}

output "eventhubs_authorizationrules_primary_connection_string" {
  description = "The primary connection string for EventHubs authorization rule"
  sensitive   = true
  value = {
    for rule in azurerm_eventhub_authorization_rule.eventhubrule :
    "${rule.eventhub_name}-${rule.name}" => rule.primary_connection_string
  }
}

output "eventhubs_authorizationrules_secondary_key" {
  description = "The secondary key for EventHubs authorization rule"
  sensitive   = true
  value = {
    for rule in azurerm_eventhub_authorization_rule.eventhubrule :
    "${rule.eventhub_name}-${rule.name}" => rule.secondary_key
  }
}

output "eventhubs_authorizationrules_secondary_connection_string" {
  description = "The secondary connection string for EventHubs authorization rule"
  sensitive   = true
  value = {
    for rule in azurerm_eventhub_authorization_rule.eventhubrule :
    "${rule.eventhub_name}-${rule.name}" => rule.secondary_connection_string
  }
}