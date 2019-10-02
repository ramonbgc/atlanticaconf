# Configure the provider to reach Azure
provider "azurerm" {
    version = "=1.34.0"
}

terraform {
  backend "remote" {
    organization = "ramongc"

    workspaces {
      name = "atlanticaconf"
    }
  }
}