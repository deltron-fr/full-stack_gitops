terraform {
  backend "azurerm" {
    resource_group_name  = "terraformstate"
    storage_account_name = "terraformstate001"
    container_name       = "terraformcontainer"
    key                  = "terraform.tfstate"
  }
}