resource "azurerm_storage_account" "sac" {
  name = "${var.project.name}${var.environment}sa01"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${azurerm_resource_group.rg.location}"

  account_kind              = "BlobStorage"
  account_tier              = "Standard"
  access_tier               = "Hot"
  account_replication_type  = "LRS"

  tags                      = "${var.tags}"
}

resource "azurerm_storage_container" "sc" {
  name                  = "destination"
  storage_account_name  = "${azurerm_storage_account.sac.name}"
  container_access_type = "private"
}