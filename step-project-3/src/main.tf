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


#создали привтаный ключ
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#создали публичный ключ
resource "aws_key_pair" "ssh-key" {
  key_name   = "Ioann-sp3-keys"
  public_key = tls_private_key.ssh.public_key_openssh
}

#записали приватный ключ в файл
resource "local_file" "ssh-key" {
  content         = tls_private_key.ssh.private_key_openssh
  filename        = "${path.module}/ioann-private.key"
  file_permission = "0400"
}


#собрали vpc из модуля
module "vpc" {
  source = "./modules/network"

  vpc_cidr_block = "13.0.0.0/16"
  public_subnet_cidr = [
    "13.0.20.0/24"
  ]
  private_subnet_cidr = [
    "13.0.21.0/24"
  ]
}


#создали публичный инстанс
resource "aws_instance" "hw-instance-public" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = "t3.medium"
  subnet_id              = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  key_name               = aws_key_pair.ssh-key.key_name


   root_block_device {
    volume_size = 30      # розмер диска в ГБ
    volume_type = "gp2"   # тип диска
  }


  tags = {
    Name  = "ioann Jenkins Master"
    Owner = "Ioann"
    Role  = "jenkins-master"
  }
}


#создали приватный инстанс spot
resource "aws_instance" "hw-instance-private" {
  ami                    = data.aws_ami.amazon-linux.id
  instance_type          = "t3.medium"
  subnet_id              = module.vpc.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  key_name               = aws_key_pair.ssh-key.key_name

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price                   = "0.04"
      spot_instance_type          = "one-time"
      instance_interruption_behavior = "terminate"
    }
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name         = "ioann Jenkins Slave"
    Owner        = "Ioann"
    Role         = "jenkins-slave"
    InstanceType = "spot"
  }
}






#Создали секьюрити группу для инстансов
resource "aws_security_group" "ec2-sg" {
  name   = "EC2-SSH-HTTP"
  vpc_id = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [80, 22, 8080, 50000]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Разрешаем весь трафик между инстансами в VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Jenkins-SG"
    Owner = "Ioann"
  }
}

# Добавляем переменную для CIDR блока VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "13.0.0.0/16"
}
