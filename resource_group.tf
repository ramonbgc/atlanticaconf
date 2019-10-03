resource "azurerm_resource_group" "rg" {
  name = "${var.project.name}-rg"
  location = "${var.region.name}"

  tags = "${var.tags}"
}