terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=2.81.0"
        }
    
    }
  
}
provider "azurerm" {
    features {}
  
}
resource "azurerm_resource_group" "davinder-test" {
    name = "davinder-resources"
    location = "eastus"
    tags = {
      "X-Environment" = "lab"
      "X-Customer" = "self"
      "x-owner" = "davinder.singh@progress.com"
    }
}

resource "azurerm_virtual_network" "davinder-vnet" {
    name = "davinder-network"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.davinder-test.location
    resource_group_name = azurerm_resource_group.davinder-test.name
}
resource "azurerm_subnet" "davinder-subnet" {
    name = "davinder-subnet-internal"
    address_prefixes = ["10.0.2.0/24"]
    resource_group_name = azurerm_resource_group.davinder-test.name
    virtual_network_name = azurerm_virtual_network.davinder-vnet.name
}
resource "azurerm_network_interface" "davinder-network-interface" {
    name = "davinder-nic"
    location = azurerm_resource_group.davinder-test.location
    resource_group_name = azurerm_resource_group.davinder-test.name
    
    ip_configuration {
        subnet_id = azurerm_subnet.davinder-subnet.id
        name = "internal"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.davinder-mypublic-ip.id
        
           }  
    
}
resource "azurerm_public_ip" "davinder-mypublic-ip" {
    name = "mypublicip"
    resource_group_name = azurerm_resource_group.davinder-test.name
    location = azurerm_resource_group.davinder-test.location
    allocation_method = "Dynamic"
    sku = "Basic"
}
resource "azurerm_network_security_group" "davinder-SG" {
    name = "davinder-mysg"
    location = azurerm_resource_group.davinder-test.location
    resource_group_name = azurerm_resource_group.davinder-test.name
    security_rule {
    name                       = "all_ports"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }
}
resource "azurerm_linux_virtual_machine" "davinder-automate" {
    name = "davinder-centos-automate"
    resource_group_name = azurerm_resource_group.davinder-test.name
    location = azurerm_resource_group.davinder-test.location    
    size = "Standard_B1s"
    admin_username = "adminuser"
    network_interface_ids = [
        azurerm_network_interface.davinder-network-interface.id
        ]
    tags = {
      "X-Environment" = "lab"
      "X-Customer" = "self"
      "x-owner" = "davinder.singh@progress.com"
    }
    # admin_ssh_key {
    #     username = "adminuser"
    #     public_key = file("/Users/dasingh/.ssh/ysingh.pub")
    # }
    admin_password = "Welcome@axainfotech123"
    disable_password_authentication = false
    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    
    source_image_reference {
        publisher = "OpenLogic"
        offer = "CentOS"
        sku = "7.5"
        version = "latest"
        
    }
#     connection {
#        type = "ssh"
#        user = "adminuser"
#        password = "Welcome@axainfotech123"
#        host = azurerm_public_ip.davinder-mypublic-ip.ip_address
#        port = 22
     
#    }
provisioner "file" {
    source = "webserver.sh"
    destination = "/tmp/webserver.sh"
    connection {
        type = "ssh"
        user = "adminuser"
        host = azurerm_public_ip.davinder-mypublic-ip.fqdn
        password = "Welcome@axainfotech123"
      
    }

}
    
#    provisioner "remote-exec" {
#        inline = [
#          "/bin/bash /tmp/webserver.sh"
#        ]
#        connection {
#        type = "ssh"
#        user = "adminuser"
#        password = "Welcome@axainfotech123"
#        host = azurerm_public_ip.davinder-mypublic-ip.ip_address
#        port = 22
     
#    }
#    } 
 
}
