resource "azurerm_data_factory" "df" {
  name                = "${var.project.name}-${var.environment}-df-01"
  location            = "${var.region.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  identity {
    type = "SystemAssigned"
  }

  tags = "${var.tags}"
}