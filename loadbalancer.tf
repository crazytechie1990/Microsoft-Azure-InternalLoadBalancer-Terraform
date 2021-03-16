resource "azurerm_lb" "az_loadbalancer" {
  name                = "TestLoadBalancer"
  location            =  azurerm_resource_group.az_project-rg.location
  resource_group_name =  azurerm_resource_group.az_project-rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "IPAddress"
    subnet_id = azurerm_subnet.az_subnet_lb.id
      }
  depends_on = [azurerm_subnet.az_subnet_lb]
}

resource "azurerm_lb_probe" "az_lb_probe" {
  resource_group_name = azurerm_resource_group.az_project-rg.name
  loadbalancer_id     = azurerm_lb.az_loadbalancer.id
  name                = "http-running-probe"
  port                = 80
  protocol            = "Http"
  request_path        = "/"
  depends_on = [azurerm_lb.az_loadbalancer]
}

resource "azurerm_lb_rule" "az_lb_rule" {
  resource_group_name            = azurerm_resource_group.az_project-rg.name
  loadbalancer_id                = azurerm_lb.az_loadbalancer.id
  frontend_ip_configuration_name = azurerm_lb.az_loadbalancer.frontend_ip_configuration[0].name
  name                           = "myHTTPRule"
  protocol                       = "Tcp"  
  frontend_port                  = 80
  backend_port                   = 80
  depends_on = [ azurerm_lb_probe.az_lb_probe ]
}

