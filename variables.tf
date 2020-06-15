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
  description = "A VPC network (self-link) that can access the MySQL instance via private IP. Can set to \"null\" if \"var.public_access\" is set to \"true\"."
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

variable "name_padding_master" {
  description = "Portion of name to be generated for the \"Master\" instance. The same name of a deleted master instance cannot be reused for up to 7 days. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes."
  type        = string
  default     = "v1"
}

variable "name_padding_failover" {
  description = "Portion of name to be generated for the \"Failover\" instance. The same name of a deleted failover instance cannot be reused for up to 7 days. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes. Maintain the given format (with a leading hyphen) for readability in GCP console."
  type        = string
  default     = "-v1"
}

variable "name_padding_replica" {
  description = "Portion of name to be generated for the \"ReadReplica\" instances. The same name of a deleted read-replica instance cannot be reused for up to 7 days. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes. Maintain the given format (with leading & trailing hyphens) for readability in GCP console."
  type        = string
  default     = "-v1-"
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

variable "instance_size_master" {
  description = "The machine type/size of \"Master\" instance. See https://cloud.google.com/sql/pricing#2nd-gen-pricing."
  type        = string
  default     = "db-f1-micro"
}

variable "instance_size_failover" {
  description = "The machine type/size of \"Failover\" instance. See https://cloud.google.com/sql/pricing#2nd-gen-pricing."
  type        = string
  default     = "db-f1-micro"
}

variable "instance_size_replica" {
  description = "The machine type/size of \"ReadReplica\" instances. See https://cloud.google.com/sql/pricing#2nd-gen-pricing."
  type        = string
  default     = "db-f1-micro"
}

variable "backup_enabled" {
  description = "Specify whether backups should be enabled for the MySQL instance."
  type        = bool
  default     = false
}

variable "pit_recovery_enabled" {
  description = "Specify whether Point-In-Time recoevry should be enabled for the MySQL instance. It uses the \"binary log\" feature of CloudSQL. Value of 'true' requires 'var.backup_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "highly_available" {
  description = "Whether the MySQL instance should be highly available (REGIONAL) or single zone. Value of 'true' requires 'var.pit_recovery_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "read_replica_size" {
  description = "Specify the number of read replicas for the MySQL instance. Value greater than 0 requires 'var.pit_recovery_enabled' to be 'true'."
  type        = number
  default     = 0
}

variable "failover_enabled" {
  description = "Specify whether failover replicas should be enabled for the MySQL instance. Value of 'true' requires 'var.pit_recovery_enabled' to be 'true'."
  type        = bool
  default     = false
}

variable "authorized_networks" {
  description = "External networks that can access the MySQL databases through HTTPS."
  type = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "public_access" {
  description = "Whether public IPv4 address should be assigned to the MySQL instance(s). If set to 'false' then 'var.private_network' must be defined."
  type        = bool
  default     = false
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
