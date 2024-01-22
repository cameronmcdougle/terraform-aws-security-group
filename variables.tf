variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "create_http_rule" {
  description = "Whether to create http rule for security group"
  type        = bool
  default     = true
}

variable "create_https_rule" {
  description = "Whether to create https rule for security group"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Time to wait for a security group to be created"
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Time to wait for a security group to be deleted"
  type        = string
  default     = "15m"
}
