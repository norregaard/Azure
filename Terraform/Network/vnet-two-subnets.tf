terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#build azure resource group
resource "azurerm_resource_group" "main" {
  name = "rg-tf-network-01"
  location = "westeurope"
  
}
resource "azurerm_virtual_network" "mainnetwork" {
  name = "vnet-tf-weu-001"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space = ["10.102.0.0/18"]
}
resource "azurerm_subnet" "snet1" {
  name = "snet-tf-weu-001"
  resource_group_name = azurerm_resource_group.main.name
  address_prefixes = ["10.102.0.0/24"]
  virtual_network_name = azurerm_virtual_network.mainnetwork.name
}
resource "azurerm_subnet" "snet2" {
  name = "snet-tf-weu-002"
  resource_group_name = azurerm_resource_group.main.name
  address_prefixes = ["10.102.1.0/24"]
  virtual_network_name = azurerm_virtual_network.mainnetwork.name
}
