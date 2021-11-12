terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=2.81.0"
        }
    
    }
  
}
provider "azurerm" {
    features {
      
    }
  
}
resource "azurerm_resource_group" "davinder-test" {
    name = "davinder-resources"
    location = "East US"
  
}
resource "azurerm_virtual_network" "davinder-vnet" {
    name = "davinder-network"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.davinder-test
    resource_group_name = azurerm_resource_group.davinder-test
}
resource "azurerm_subnet" "davinder-subnet" {
    name = "davinder-subnet-internal"
    address_prefixes = ["10.0.2.0/24"]
    resource_group_name = azurerm_resource_group.davinder-test
    virtual_network_name = azurerm_virtual_network.davinder-vnet 
}
resource "azurerm_network_interface" "davinder-network-interface" {
    name = "davinder-nic"
    location = azurerm_resource_group.davinder-test
    resource_group_name = azurerm_resource_group.davinder-test
    ip_configuration {
        subnet_id = azurerm_subnet.davinder-subnet
        name = "internal"
        private_ip_address_allocation = "Dynamic"
    }  
}
resource "azurerm_linux_virtual_machine" "davinder-automate" {
    name = "davinder-centos-automate"
    resource_group_name = azurerm_resource_group.davinder-test
    location = azurerm_resource_group.davinder-test
    size = "Standard_B1s"
    admin_username = "adminuser"
    network_interface_ids = [
        azurerm_network_interface.
    ]

  
}
