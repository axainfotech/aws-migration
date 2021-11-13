output "Public_IP" {
    value = azurerm_public_ip.davinder-mypublic-ip.ip_address
}
output "VM_Name" {
    value = azurerm_linux_virtual_machine.davinder-automate.name
}
output "FQDN" {
    value = azurerm_public_ip.davinder-mypublic-ip.fqdn
}
output "public-ip-new" {
    value = azurerm_public_ip.davinder-mypublic-ip
}