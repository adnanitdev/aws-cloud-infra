variable "instance_type" {
  description = "The type of EC2 instance for the bastion host."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the bastion host."
  type        = string
}