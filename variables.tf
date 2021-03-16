variable "nics" {
  type = list
  default = ["Nic1", "Nic2", "Nic3"]
}

variable "Machines" {
  type = list
  default = ["Machine1", "Machine2"]
}


variable "IP_Config_Name" {
  default = "ip_config"
}