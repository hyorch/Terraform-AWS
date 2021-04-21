# variables.tf

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "Jenkins-Ubuntu"
}

variable "ssh_key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "DevOpsAws"
}


variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}