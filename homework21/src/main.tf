module "nginx_instance" {
  source             = "./modules/ng-instance"
  vpc_id             = var.vpc_id
  list_of_open_ports = var.list_of_open_ports
}

data "aws_ami" "amazon-linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
} 

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"
  content  = templatefile("${path.module}/inventory.tpl", {
    instance_ips = module.nginx_instance.instance_public_ips
  })
}
