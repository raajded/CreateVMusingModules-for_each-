output "azurerm_subnet" {
  value = [for subnet in values(azurerm_subnet.subnet): subnet.id]
}