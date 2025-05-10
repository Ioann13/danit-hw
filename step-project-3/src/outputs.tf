
output "public_ec2_ip" {
  value = aws_instance.hw-instance-public.public_ip
}

output "private_ec2_ip" {
  value = aws_instance.hw-instance-private.private_ip
}

output "private-ssh-key" {
  value     = tls_private_key.ssh.private_key_openssh
  sensitive = true
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
