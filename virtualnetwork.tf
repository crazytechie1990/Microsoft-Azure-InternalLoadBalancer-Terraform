resource "azurerm_resource_group" "az_project-rg" {
  name     = "CreateIntLBQS-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "az_vnet" {
  name                = "myVNet"
  location            = azurerm_resource_group.az_project-rg.location
  resource_group_name = azurerm_resource_group.az_project-rg.name
  address_space       = ["10.1.0.0/16"]
  depends_on = [ "azurerm_resource_group.az_project-rg" ]
  }

resource "azurerm_subnet" "az_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.az_project-rg.name
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
  depends_on = [ "azurerm_virtual_network.az_vnet" ]
}

resource "azurerm_public_ip" "az_bastion_ip" {
  name                = "myBastionIP"
  location            = azurerm_resource_group.az_project-rg.location
  resource_group_name = azurerm_resource_group.az_project-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [  "azurerm_subnet.az_subnet"]
}

resource "azurerm_bastion_host" "az_bastion_host" {
  name                = "myBastionHost"
  location            = azurerm_resource_group.az_project-rg.location
  resource_group_name = azurerm_resource_group.az_project-rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.az_subnet.id
    public_ip_address_id = azurerm_public_ip.az_bastion_ip.id
  }
  depends_on = [ "azurerm_public_ip.az_bastion_ip"]
}

resource "azurerm_subnet" "az_subnet_lb" {
  name                 = "AzureLoadBalancerSubnet"
  resource_group_name  = azurerm_resource_group.az_project-rg.name
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes     = ["10.1.0.0/24"]
  depends_on = [ azurerm_bastion_host.az_bastion_host ]
}
