variable "vm_instances" {
  type = map(object({
    name                          = string
    backend_pool_name             = string
    private_ip_address_allocation = string
  }))
  default = {
    "vm1" = {
      name                          = "vm1"
      backend_pool_name             = "pool1"
      private_ip_address_allocation = "Dynamic"

    }

    "vm2" = {
      name                          = "vm2"
      backend_pool_name             = "pool1"
      private_ip_address_allocation = "Dynamic"

    }
  }
  description = "Virtual machine instances of the linus machines"

}

variable "backend_address_pool_names" {
  type        = list(string)
  default     = ["pool1", "pool2"]
  description = "Backend pool names of the backend servers"
}

variable "nsg" {
  type        = string
  default     = "app-gw-nsg"
  description = "(Required) Specifies the name of the network security group. Changing this forces a new resource to be created."

}

variable "nsg_rules" {
  type = map(object({
    name        = string
    priority    = number
    direction   = string
    access      = string
    protocol    = string
    source_port = string
    dest_port   = string
    source_addr = string
    dest_addr   = string
  }))
  default = {
    "http-vm" = {
      name        = "http-vm"
      priority    = 100
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "Tcp"
      source_port = "*"
      dest_port   = "80"
      source_addr = "*"
      dest_addr   = "*"
    }

    "ssh-vm" = {
      name        = "ssh-vm"
      priority    = 110
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "Tcp"
      source_port = "*"
      dest_port   = "22"
      source_addr = "*"
      dest_addr   = "*"
    }

    "vm-internet" = {
      name        = "vm-internet"
      priority    = 120
      direction   = "Outbound"
      access      = "Allow"
      protocol    = "Tcp"
      source_port = "*"
      dest_port   = "*"
      source_addr = "*"
      dest_addr   = "Internet"
    }


  }
  description = "(Required) The name of the security rule. This needs to be unique across all Rules in the Network Security Group. Changing this forces a new resource to be created."

}
