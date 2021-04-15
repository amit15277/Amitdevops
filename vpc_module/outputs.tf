######## networking/outputs.tf
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "vpc id"
}

output "nat_gw_id" {
  value       = aws_nat_gateway.nat_gw.*.id
  description = "nat gateway id"
}

output "internet_gw_id" {
  value       = aws_internet_gateway.internet_gw.*.id
  description = "internet gateway id"
}

output "public_subnet_id" {
  value       = aws_subnet.public_subnet.*.id
  description = "public subnet ids"
}

output "public_rt_id" {
  value       = aws_route_table.public_rt.*.id
  description = "public route table ids"
}

output "private_subnet_id" {
  value       = aws_subnet.private_subnet.*.id
  description = "private subnet ids"
}

output "private_cidrs" {
  value       = aws_subnet.private_subnet.*.cidr_block
  description = "private subnet ids"
}

output "private_rt_id" {
  value       = aws_default_route_table.private_rt.id
  description = "private route table ids"
}


