variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "13.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = list(string)
  default = [
    "13.0.20.0/24"
  ]
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list(string)
  default = [
    "13.0.21.0/24"
  ]
}

variable "owner" {
  description = "Default owner for all AWS services"
  type        = string
  default     = "Ioann"
}
