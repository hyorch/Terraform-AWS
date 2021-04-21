# variables.tf

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleInstance"
}

variable "ssh_key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "DevOpsAws"
}
