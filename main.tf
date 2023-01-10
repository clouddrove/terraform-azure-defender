
resource "azurerm_advanced_threat_protection" "example" {
  target_resource_id = var.resource_id
  enabled            = var.enabled
}
