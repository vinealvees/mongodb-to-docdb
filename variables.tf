variable "region" {
  description = "AWS region where the provider will operate."
  type        = string
  default     = "us-west-2"
}

variable "default_tags" {
  description = "Configuration block with resource tag settings to apply across all resources handled by this provider"
  type        = map(string)
  default = {
    Managed = "By Terraform"
    Project = "mongodb-migration-to-documentdb"
  }
}

variable "instance_type" {
  description = "Instance type to use for the instance."
  type        = string
  default     = "t2.micro"
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  type        = string
  default     = ""
}