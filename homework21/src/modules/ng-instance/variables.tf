variable "vpc_id" {
  type = string
}

variable "list_of_open_ports" {
  description = "List of ports which should be opened for security group"  
  type = list(number)

}