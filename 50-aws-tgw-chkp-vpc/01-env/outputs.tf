output "spoke_vpc_a_id" {
  value = aws_vpc.spoke_vpc_a.id
}
output "spoke_vpc_b_id" {
  value = aws_vpc.spoke_vpc_b.id
}

output "spoke_vpc_a_protected_subnet_a_id" {
  value = aws_subnet.spoke_vpc_a_protected_subnet[0].id
}
output "spoke_vpc_b_protected_subnet_a_id" {
  value = aws_subnet.spoke_vpc_b_protected_subnet[0].id
}