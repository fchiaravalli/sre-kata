output "ids" {
  value = aws_nat_gateway.nat[*].id
}

output "public_ips" {
  value = aws_nat_gateway.nat[*].public_ip
}
