
output "gwlbe_subnet_ids" {
  value =     aws_subnet.inspection_vpc_gwlbe_subnet[*].id
}

output "gwlbe_ids" {
  value =     [aws_vpc_endpoint.gwlb_endpoint1.id, 
                aws_vpc_endpoint.gwlb_endpoint2.id, 
                aws_vpc_endpoint.gwlb_endpoint3.id]
}