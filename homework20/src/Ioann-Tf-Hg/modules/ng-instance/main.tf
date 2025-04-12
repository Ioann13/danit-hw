resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow selected ports"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.list_of_open_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "ioann-nginx-sg"
    Owner = "Ioann"         
  }
}
resource "aws_instance" "nginx" {
  ami           = "ami-0bade3941f267d2b8"
  instance_type = "t2.micro"
  key_name = "Ioann-frankfurd-Dan"
  user_data_replace_on_change = true

  security_groups = [aws_security_group.nginx_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum -y update
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
            EOF

    tags = {
    Name = "ioann-nginx-instance"
    Owner = "Ioann"
  }

  associate_public_ip_address = true
}