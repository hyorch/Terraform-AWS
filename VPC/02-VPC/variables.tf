variable "region" { 
  type        = string
  description = "Region of the VPC"
}

variable "vpc_name" { 
  type        = string
  description = "VPC Name"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_blocks" {
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  type        = list
  description = "List of availability zones"
}
 