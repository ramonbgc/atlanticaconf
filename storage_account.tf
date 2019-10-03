resource "azurerm_storage_account" "sac" {
  name = "${var.project.name}sa01"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${azurerm_resource_group.rg.location}"

  account_kind              = "StorageV2"
  account_tier              = "Standard"
  access_tier               = "Hot"
  account_replication_type  = "LRS"

  is_hns_enabled            = true

  tags                      = "${var.tags}"
}

resource "azurerm_storage_container" "sc" {
  name                  = "destination"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  storage_account_name  = "${azurerm_storage_account.sac.name}"
  container_access_type = "private"
}