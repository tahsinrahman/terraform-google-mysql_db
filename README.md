Terraform module for a MySQL CloudSQL Instance in GCP

## Declaring authorized networks
```terraform
module "mysql_db" {
  .....
  .....
  authorized_networks_master_instance = [
    {
      display_name = "Corporate IPs"
      cidr_block   = "192.168.1.0/30"
    }
  ]
  authorized_networks_read_replica = [
    {
      display_name = "QA Teams"
      cidr_block   = "192.168.2.0/28"
    }
  ]
  authorized_networks_failover_replica = [
    {
      display_name = "Corporate IPs"
      cidr_block   = "192.168.1.0/30"
    },
    {
      display_name = "South Gate IPs"
      cidr_block   = "192.169.3.0/24"
    }
  ]
  .....
  .....
}
```
