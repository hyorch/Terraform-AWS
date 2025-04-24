# variables.tf

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "Jenkins-Ubuntu"
}

variable "ssh_key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "DevOpsAWS-2025"
}

variable "input_port_list" {
  description = "List of ports to open in the security group"
  type        = list(number)
  default     = [22, 8080, 9000]
}