variable "vpc_id" {
  type        = string
  description = "VPC ID for the instance and security group"
}

variable "list_of_open_ports" {
  type        = list(number)
  description = "List of ports to open in the security group"
}