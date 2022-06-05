# Variables
variable "server_port" {
  description = "Server port Running httpd"
  default     = 8080
  type        = number
}

variable "server_ssh_port" {
  description = "Server port Running SSH"
  default     = 22
  type        = number
}