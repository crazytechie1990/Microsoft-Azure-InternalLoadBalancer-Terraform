variable "lb_location" {
  default = "West Europe"
}

variable "nics" {
  type = list
  default = ["Nic1", "Nic2", "Nic3", "Nic4"]
}

variable "Machines" {
  default = ["Machine1"]
}


variable "IP_Config_Name" {
  default = "ip_config"
}