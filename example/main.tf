provider "azurerm" {
  features {}
}

module "resource_group" {
  source  = "clouddrove/resource-group/azure"
  version = "1.0.0"

  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
  location    = "Canada Central"
}

##    Storage Account
module "storage" {
  source                    = "clouddrove/storage/azure"
  resource_group_name       = module.resource_group.resource_group_name
  location                  = module.resource_group.resource_group_location
  storage_account_name      = "storagestartaca"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  is_hns_enabled            = true
  sftp_enabled              = true

  network_rules = [
    {
      default_action = "Deny"
      ip_rules       = ["0.0.0.0/0"]
      bypass         = ["AzureServices"]
    }
  ]


  ##   Storage Account Threat Protection
  enable_advanced_threat_protection = true

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

  management_policy = [
    {
      prefix_match               = ["app-test/folder_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 50
      delete_after_days          = 100
      snapshot_delete_after_days = 30
    }
  ]
}

module "defender" {
  source      = "./../"
  enabled     = true
  resource_id = module.storage.storage_account_id
}
