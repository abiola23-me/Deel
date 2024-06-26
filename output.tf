output "instance_id" {
  value = aws_instance.app_a.id
}

output "instance_public_ip" {
  value = aws_eip.nat.public_ip
}
