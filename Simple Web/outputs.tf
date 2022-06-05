#Outputs
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.simple-web.public_ip
}

output "ubuntu_image" {
  value = data.aws_ami.ubuntu.id
}