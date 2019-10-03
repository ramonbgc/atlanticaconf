# Configure the provider to reach Azure
provider "azurerm" {
    version = "~>1.34.0"

  ### if using tfvars and not the Terraform Cloud
  # subscription_id = "${var.subscription_id}"
  # client_id = "${var.client_id}"
  # client_secret = "${var.client_secret}"
  # tenant_id = "${var.tenant_id}"
}

terraform {
  backend "remote" {
    organization = "ramongc"

    workspaces {
      name = "atlanticaconf"
    }
  }

  ### if using azure storage account and not the Terraform Cloud as backend
  #  backend "azurerm" {
  #    resource_group_name   = "generaluse-rg"
  #    storage_account_name  = "rgcgeneralusesa"
  #    container_name        = "tfstate"
  #    key                   = "terraform.tfstate"
  #  }


}