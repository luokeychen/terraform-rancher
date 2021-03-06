variable "name" {}

variable "availability_zone" {}

variable "primary_snapshot_id" {
  default = ""
}

variable "backup_snapshot_id" {
  default = ""
}

variable "primary_volume_size" {
  default = 100
}

variable "primary_volume_type" {
  default = "gp2"
}

variable "backup_volume_size" {
  default = 100
}

variable "backup_volume_type" {
  default = "standard"
}
