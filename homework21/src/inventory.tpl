[web]
%{ for ip in instance_ips ~}
${ip} ansible_user=ec2-user ansible_ssh_private_key_file=/home/ioann/.ssh/Ioann-frankfurd-Dan.pem
%{ endfor ~}

[all:vars]
ansible_python_interpreter=/usr/bin/python3