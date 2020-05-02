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
  description = "A VPC network (self-link) that can access the MySQL instance via private IP. Can set to 'null' if 'ipv4_enabled' is set to 'true'."
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

variable "name_padding" {
  description = "Any arbitrary characterset which will be used as a padding for the \"CloudSQL\" instance name. It's useful if an instance was deleted and a new one needs to be created as we cannot re-use the same name of a deleted instance for up to 7 days. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes."
  type        = string
  default     = "v1"
}

variable "failover_name_padding" {
  description = "Any arbitrary characterset which will be used as a padding for the \"FailOver\" instance name. It's useful if an instance was deleted and a new one needs to be created as we cannot re-use the same name of a deleted instance for up to 7 days. Maintain the given default format (with hyphen) for readability in GCP console. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes"
  type        = string
  default     = "-v1"
}

variable "replica_name_padding" {
  description = "Any arbitrary characterset which will be used as a padding for the \"ReadReplica\" instance name. It's useful if an instance was deleted and a new one needs to be created as we cannot re-use the same name of a deleted instance for up to 7 days. Maintain the given default format (with hyphens) for readability in GCP console. See https://cloud.google.com/sql/docs/mysql/delete-instance > notes"
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

variable "instance_size" {
  description = "The machine type/size for the MySQL instances. See https://cloud.google.com/sql/pricing#2nd-gen-pricing."
  type        = string
  default     = "db-f1-micro"
}

variable "highly_available" {
  description = "Whether the MySQL instance should be highly available (REGIONAL) or single zone. Value of 'true' requires 'var.pit_recovery_enabled' to be 'true'."
  type        = bool
  default     = false
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

variable "read_replica_size" {
  description = "Specify the number of read replicas for the MySQL instance. Value greater than 0 requires 'var.pit_recovery_enabled' to be 'true'."
  type        = number
  default     = 0
}

variable "failover_replica_enabled" {
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

variable "ipv4_enabled" {
  description = "Whether public IPv4 address should be assigned to the MySQL instance. If set to 'false' then 'var.private_network' must be defined."
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Name of the default database to be created."
  type        = string
  default     = "default"
}

variable "db_instance_name" {
  description = "The name of the database instance."
  type        = string
  default     = null
}
