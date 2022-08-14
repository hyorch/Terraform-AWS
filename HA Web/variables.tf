# Variables
variable region{
  default = "eu-west-1" #Ireland 
}

variable "ssh_key_name" {
  default = "DevOpsAWS"   
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "elb_port" {
  description = "The port the ELB will use for HTTP requests"
  type        = number
  default     = 80
}