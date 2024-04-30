variable "vm" {
  type = map(object({
    rg_name = string
    rg_location = string
    vm_name = string
    vnet_name = string
    subnet_name = string
    nic_name = string
  }))
  
  default = {
    "vm1" = {
      rg_name = "My-Rg"
      rg_location = "Central India"
      vm_name = "Vm-1"
    vnet_name = "Vnet-1"
    subnet_name = "Subnet-1"
    nic_name = "Nic-1"
    }
  }
  }



 