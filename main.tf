locals {
  tmp_eventhub_namespace_name = var.eventhub_namespace != "" ? var.eventhub_namespace : "eventhub-${var.shortprojectlabel}-${var.region}-${var.environment}"
  eventhub_namespace_name     = lower(local.tmp_eventhub_namespace_name)
}

##################################################
################       Namespace

resource "azurerm_eventhub_namespace" "namespace" {
  name                = local.eventhub_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity

  tags = var.tags
}

################       Authorization Rules

resource "azurerm_eventhub_namespace_authorization_rule" "namespacerule" {
  count               = length(var.namespace_authorization_rules)
  name                = lower(var.namespace_authorization_rules[count.index].name)
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name

  listen = var.namespace_authorization_rules[count.index].listen
  send   = var.namespace_authorization_rules[count.index].send
  manage = var.namespace_authorization_rules[count.index].manage
}

##################################################
################       EventHubs

resource "azurerm_eventhub" "eventhub" {
  count               = length(var.eventhubs)
  name                = lower(var.eventhubs[count.index].name)
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  resource_group_name = var.resource_group_name
  partition_count     = var.eventhubs[count.index].partition_count
  message_retention   = var.eventhubs[count.index].message_retention
}

################       Consumer Groups

# Create a map for consumer groups associated to the correct EventHub
locals {
  listconsumergroups = flatten([
    for hub in var.eventhubs : [
      for consumergroup in hub.consumer_groups : {
        "${hub.name}-${consumergroup}" = {
          consumergroup = consumergroup
          hub           = hub.name
        }
    }]
  ])

  mapconsumergroups = { for item in local.listconsumergroups :
    keys(item)[0] => values(item)[0]
  }
}

resource "azurerm_eventhub_consumer_group" "consumergroup" {
  for_each            = local.mapconsumergroups
  name                = lower(each.value.consumergroup)
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = each.value.hub
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_eventhub.eventhub,
  ]
}

################       Authorization Rules

# Create a map for authorization rules associated to the correct EventHub
locals {
  listauthorizationrules = flatten([
    for hub in var.eventhubs : [
      for authorizationrule in hub.authorization_rules : {
        "${hub.name}-${authorizationrule.name}" = {
          rulename = authorizationrule.name
          listen   = authorizationrule.listen
          send     = authorizationrule.send
          manage   = authorizationrule.manage
          hub      = hub.name
        }
    }]
  ])

  mapauthorizationrules = { for item in local.listauthorizationrules :
    keys(item)[0] => values(item)[0]
  }
}

resource "azurerm_eventhub_authorization_rule" "eventhubrule" {
  for_each            = local.mapauthorizationrules
  name                = lower(each.value.rulename)
  namespace_name      = azurerm_eventhub_namespace.namespace.name
  eventhub_name       = each.value.hub
  resource_group_name = var.resource_group_name
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage

  depends_on = [
    azurerm_eventhub.eventhub,
  ]
}