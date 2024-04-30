resource "azurerm_resource_group" "reg" {
  name     = each.value.rg_name
  location = each.value.rg_location
  for_each = var.vm
}

resource "azurerm_virtual_network" "vnet" {
  name                = each.value.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.reg[each.key].location
  resource_group_name = azurerm_resource_group.reg[each.key].name
for_each = var.vm
}

resource "azurerm_subnet" "subnet" {
  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.reg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = ["10.0.2.0/24"]
  for_each = var.vm
}

resource "azurerm_network_interface" "nic" {
  name                = each.value.nic_name
  location            = azurerm_resource_group.reg[each.key].location
  resource_group_name = azurerm_resource_group.reg[each.key].name
for_each = var.vm

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = each.value.vm_name
  location              = azurerm_resource_group.reg[each.key].location
  resource_group_name   = azurerm_resource_group.reg[each.key].name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  vm_size               = "Standard_DS1_v2"

for_each = var.vm

   delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = each.value.vm_name
    admin_username = "prashant"
    admin_password = "Azure@1234567"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "Test"
  }
}