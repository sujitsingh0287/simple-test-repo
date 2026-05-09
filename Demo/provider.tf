terraform {
  required_providers {
    azurerm = {
      source  = "Hashicorp/azurerm"
      version = "4.67.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "b19c0e3e-ac3c-4ac4-97b5-1489c19fdbef"
}
