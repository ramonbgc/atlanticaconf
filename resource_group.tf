resource "azurerm_resource_group" "rg" {
  name = "${var.project.name}-${var.environment}-rg"
  location = "${var.region.name}"

  tags = "${var.tags}"
}