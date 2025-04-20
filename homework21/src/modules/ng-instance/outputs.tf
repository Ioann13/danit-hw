output "instance_public_ip" {
  value = [for instance in aws_instance.nginx : instance.public_ip]
}
output "instance_public_ips" {
  value = aws_instance.nginx[*].public_ip
}