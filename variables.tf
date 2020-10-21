# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "name_suffix" {
  description = "An arbitrary suffix that will be added to the end of the resource name(s). For example: an environment name, a business-case name, a numeric id, etc."
  type        = string
  validation {
    condition     = length(var.name_suffix) <= 14
    error_message = "A max of 14 character(s) are allowed."
  }
}

variable "private_network" {
  description = "A VPC network (self-link) that can access the MySQL instance via private IP. Can set to \"null\" if any of \"var.public_access_*\" is set to \"true\"."
  type        = string
}

variable "module_depends_on" {
  description = "Create explicit dependency of this module on values from other modules(s) and/or resource(s). Usually, MySQL requires a dependency on VPC's peering with Google Services."
  type        = list(string)
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "user_name" {
  description = "The name of the default database user."
  type        = string
  default     = "default"
}

variable "master_instance_full_name" {
  description = "Full name of the master instance"
  type        = string
}

variable "name_master_instance" {
  description = "Portion of name to be generated for the \"Master\" instance. The same name of a deleted master instance cannot be reused for up to 7 days. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes."
  type        = string
  default     = "v1"
}

variable "name_read_replica" {
  description = "Portion of name to be generated for the \"ReadReplica\" instances. The same name of a deleted read-replica instance cannot be reused for up to 7 days. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes."
  type        = string
  default     = "v1"
}

variable "db_version" {
  description = "The MySQL database version to use. See https://cloud.google.com/sql/docs/mysql/db-versions."
  type        = string
  default     = "MYSQL_5_7"
}

variable "db_charset" {
  description = "The charset for the MySQL database."
  type        = string
  default     = "utf8"
}

variable "db_collation" {
  description = "The collation for the MySQL database."
  type        = string
  default     = "utf8_general_ci"
}

variable "instance_size_master_instance" {
  description = "The machine type/size of \"Master\" instance. See https://cloud.google.com/sql/pricing#2nd-gen-pricing."
  type        = string
  default     = "db-f1-micro"
}

variable "instance_size_read_replica" {
  description = "The machine type/size of \"ReadReplica\" instances. See https://cloud.google.com/sql/pricing#2nd-gen-pricing."
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size_gb_master_instance" {
  description = "Disk size for the master instance in Giga Bytes."
  type        = string
  default     = 10
}

variable "disk_size_gb_read_replica" {
  description = "Disk size for the read replica instance(s) in Giga Bytes."
  type        = string
  default     = 10
}

variable "disk_auto_resize_master_instance" {
  description = "Whether to increase disk storage size of the master instance automatically. Increased storage size is permanent. Google charges by storage size whether that storage size is utilized or not. Recommended to set to \"true\" for production workloads."
  type        = bool
  default     = false
}

variable "disk_auto_resize_read_replica" {
  description = "Whether to increase disk storage size of the read replica instance(s) automatically. Increased storage size is permanent. Google charges by storage size whether that storage size is utilized or not. Recommended to set to \"true\" for production workloads."
  type        = bool
  default     = false
}

variable "backup_enabled" {
  description = "Specify whether backups should be enabled for the MySQL instance."
  type        = bool
  default     = false
}

variable "backup_location" {
  description = "A string value representing REGIONAL or MULTI-REGIONAL location for storing backups. Defaults to the Google provider's region if nothing is specified here. See https://cloud.google.com/sql/docs/mysql/locations for REGIONAL / MULTI-REGIONAL values."
  type        = string
  default     = ""
}

variable "pit_recovery_enabled" {
  description = "Specify whether Point-In-Time recoevry should be enabled for the MySQL instance. It uses the \"binary log\" feature of CloudSQL. Value of 'true' requires 'var.backup_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "highly_available" {
  description = "Whether the MySQL instance should be highly available (REGIONAL) or single zone. Highly Available (HA) instances will automatically failover to another zone within the region if there is an outage of the primary zone. HA instances are recommended for production use-cases and increase cost. Value of 'true' requires 'var.pit_recovery_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "read_replica_count" {
  description = "Specify the number of read replicas for the MySQL instance. Value greater than 0 requires 'var.pit_recovery_enabled' to be 'true'."
  type        = number
  default     = 0
}

variable "authorized_networks_master_instance" {
  description = "External networks that can access the MySQL master instance through HTTPS."
  type = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "authorized_networks_read_replica" {
  description = "External networks that can access the MySQL ReadReplica instance(s) through HTTPS."
  type = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "zone_master_instance" {
  description = "The zone-letter to launch the master instance in. Options are \"a\" or \"b\" or \"c\" or \"d\". Defaults to \"a\" zone of the Google provider's region if nothing is specified here. See https://cloud.google.com/compute/docs/regions-zones."
  type        = string
  default     = "a"
}

variable "zone_read_replica" {
  description = "The zone-letter to launch the ReadReplica instance(s) in. Options are \"a\" or \"b\" or \"c\" or \"d\". Defaults to \"b\" zone of the Google provider's region if nothing is specified here. See https://cloud.google.com/compute/docs/regions-zones."
  type        = string
  default     = "b"
}

variable "public_access_master_instance" {
  description = "Whether public IPv4 address should be assigned to the MySQL master instance. If set to 'false' then 'var.private_network' must be defined."
  type        = bool
  default     = false
}

variable "public_access_read_replica" {
  description = "Whether public IPv4 address should be assigned to the MySQL read-replica instance(s). If set to 'false' then 'var.private_network' must be defined."
  type        = bool
  default     = false
}

variable "db_flags_master_instance" {
  description = "The database flags applied to the master instance. See https://cloud.google.com/sql/docs/mysql/flags"
  type        = map(string)
  default     = {}
}

variable "db_flags_read_replica" {
  description = "The database flags applied to the read replica instances. See https://cloud.google.com/sql/docs/mysql/flags"
  type        = map(string)
  default     = {}
}

variable "user_labels_master_instance" {
  description = "Key/value labels for the master instance."
  type        = map(string)
  default     = {}
}

variable "user_labels_read_replica" {
  description = "Key/value labels for the ReadReplica instance(s)."
  type        = map(string)
  default     = {}
}

variable "db_name" {
  description = "Name of the default database to be created."
  type        = string
  default     = "default"
}

variable "db_timeout" {
  description = "How long a database operation is allowed to take before being considered a failure."
  type        = string
  default     = "15m"
}

variable "sql_proxy_user_groups" {
  description = "List of usergroup emails that maybe allowed to connect with the database using CloudSQL Proxy. Connecting via CLoudSQL proxy from remote/localhost requires \"var.public_access_*\" to be set to \"true\" (for whichever of master/replica instances you want to connect to). See https://cloud.google.com/sql/docs/mysql/sql-proxy#what_the_proxy_provides"
  type        = list(string)
  default     = []
}
