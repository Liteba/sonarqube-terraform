output "public_ip" {
  value = aws_instance.sonarqube_server.public_ip 
  description = "ec2 instance public-ip"
}