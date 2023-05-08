provider "azurerm" {
  features {}
}

module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.2"

  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
  location    = "Canada Central"
}

##    Storage Account
module "storage" {
  source                   = "clouddrove/storage/azure"
  version                  = "1.0.8"
  name                     = "app"
  environment              = "test"
  label_order              = ["name", "environment"]
  default_enabled          = true
  resource_group_name      = module.resource_group.resource_group_name
  location                 = module.resource_group.resource_group_location
  storage_account_name     = "stordtyre236"
  account_replication_type = "LRS"


  ##   Storage Container
  containers_list = [
    { name = "app-test", access_type = "private" },
  ]

  ##   Storage File Share
  file_shares = [
    { name = "fileshare1", quota = 5 },
  ]

  ##   Storage Tables
  tables = ["table1"]

  ## Storage Queues
  queues = ["queue1"]

  management_policy_enable = true

  #enable private endpoint
  enable_private_endpoint = false

  enable_diagnostic = false

}

module "defender" {
  source      = "git::https://github.com/clouddrove/terraform-azure-defender.git"
  enabled     = true
  resource_id = module.storage.default_storage_account_id
}
