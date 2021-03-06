variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PRIVATE_KEY_PATH" {
  default = "ssh-keys/ssh-key-region-key-pair"
}

variable "PUBLIC_KEY_PATH" {
  default = "ssh-keys/ssh-key-region-key-pair.pub"
}

resource "random_password" "devise" {
  length           = 128
  special          = true
  override_special = "*+-./=?[]^_"
  upper            = true
  lower            = true
}

# EC2 server sizing for bastion host
variable "BASTION_TYPE" {
  default = "t2.nano"
}
variable "BASTION_AMI" {
  type = map(any)
  default = {
    us-east-1 = "ami-0ff8a91507f77f867" # HVM (SSD) EBS-Backed, 64-bit Amazon Linux 2
  }
}
variable "BASTION_SSH_CIDR_BLOCKS" {
  type    = list(any)
  default = ["0.0.0.0/0"] # for production use your IP(s)
}
variable "PRIVATE_BASTION_KEY_PATH" {
  default = "ssh-keys/ssh-public-key-region-key-pair"
}
variable "PUBLIC_BASTION_KEY_PATH" {
  default = "ssh-keys/ssh-public-key-region-key-pair.pub"
}
variable "APP_SERVER_PUBLIC_EGRESS_PORTS" {
  type    = list(any)
  default = [443, 80] # here 443 to fetch system updates. Port 80 for `yum`
}
variable "EC2_USER" {
  default = "ec2-user"
}
# EC2 server sizing for application server
variable "IFORM_TYPE" {
  default = "t2.small"
}
variable "IFORM_AMI" {
  type = map(any)
  default = {
    us-east-1 = "ami-0583a85f64c86b59a" # iForm GA Version 1.2
  }
}
variable "DATALAKE_MOUNT_POINT" {
  default = "/mnt/efs"
}

variable "CERTIFICATE_ARN" {
  type        = string
  description = "Your Amazon Certificate Manager SSL Certificate ARN"
}
variable "APP_HOST" {
  type        = string
  description = "Your domain, e.g. iform.io"
}
variable "SUBDOMAIN" {
  type        = string
  description = "Your desired subdomain, e.g. demo"
}
variable "SPP_LOG_FILE" {
  type    = string
  default = "/srv/iform/app/shared/log/spp-app.log"
}
variable "PUMA_ERROR_LOG_FILE" {
  type    = string
  default = "/srv/iform/app/shared/log/puma.stdout.log"
}
variable "PUMA_ACCESS_LOG_FILE" {
  type    = string
  default = "/srv/iform/app/shared/log/puma.stdout.log"
}

# NOTE: this is an admin username/email address that will be used to log in into the iForm Portal
variable "FROM_EMAIL" {
  type        = string
  description = "An admin Email address that will be used to log in into the iForm Portal. iForm will also sent system emails using this address (MUST BE configured as a trusted Email address in Amazon SES)"
}
variable "SCHOOL_TITLE" {
  type        = string
  description = "School Name, e.g. ABC School"
}
variable "SCHOOL_PHONE" {
  type        = string
  description = "Main Phone # that the school staff can be reached at, e.g. 206-345-6789. Phone number MUST BE in XXX-XXX-XXXX format."
}
variable "SCHOOL_SECRET_PHRASE" {
  type        = string
  description = "Enter a secret phrase or a word (can be any word you choose)"
}

variable "SMTP" {
  type = map(any)
  default = {
    "address" = "email-smtp.us-east-1.amazonaws.com"
    "port"    = 587
  }
}
# Application specific secrets BEGIN
variable "SMTP_PASSWORD" {
  type        = string
  description = "Your SMTP Password"
}
variable "SMTP_USERNAME" {
  type        = string
  description = "Your SMTP Username"
}
# Application specific secrets END

# RDS credentials and connection details
variable "DATABASE_INSTANCE" {
  type = map(any)
  default = {
    "engine_version"            = "9.6.20"
    "engine"                    = "postgres"
    "instance_class"            = "db.t2.small"
    "allocated_storage"         = 20
    "max_storage"               = 100
    "rds_ca"                    = "rds-ca-2019"
    "final_snapshot_identifier" = "iform-final-snapshot"
    "port"                      = 5432

    "backup_retention_period"  = 0     # set to desired value in production (>=7)
    "multi_az"                 = false # set to true in production
    "deletion_protection"      = false # set to true in production
    "delete_automated_backups" = true  # set to false in production
    "skip_final_snapshot"      = true  # set to false in production
  }
}
variable "RDS_CA_2019_LOCATION" {
  default     = "https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem"
  description = "From where CA file will be downloaded."
}
variable "LOCAL_CA_2019_LOCATION" {
  description = "Where CA file will be stored."
  default     = "/srv/iform/app/shared/rds-ca-2019-root.pem"
}
