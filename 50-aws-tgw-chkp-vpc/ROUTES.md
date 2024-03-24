
Enable routing through CP:

```shell
PUBRT=$(aws ec2 describe-route-tables | jq -r -c '.RouteTables[]|{id: .RouteTableId, name: .Tags[0].Value}' | jq -r 'select(.name=="inspection-vpc/eu-west-1a/public-subnet-route-table")| .id')
TGWRT=$(aws ec2 describe-route-tables | jq -r -c '.RouteTables[]|{id: .RouteTableId, name: .Tags[0].Value}' | jq -r 'select(.name=="inspection-vpc/eu-west-1a/tgw-subnet-route-table")| .id')
GWLBE=$(aws ec2 describe-vpc-endpoints --query 'VpcEndpoints[?contains(Tags[?Key==`Name`].Value, `gwlb_endpoint1`)]'| jq -r '.[0].VpcEndpointId')

echo $PUBRT $TGWRT $GWLBE

### via CP
aws ec2 delete-route --route-table-id $TGWRT --destination-cidr-block 0.0.0.0/0 
aws ec2 create-route --route-table-id $TGWRT --destination-cidr-block 0.0.0.0/0  --vpc-endpoint-id $GWLBE

aws ec2 delete-route --route-table-id $PUBRT --destination-cidr-block 10.0.0.0/8 
aws ec2 create-route --route-table-id $PUBRT --destination-cidr-block 10.0.0.0/8   --vpc-endpoint-id $GWLBE
```

Direct routing bypassing Check Point:

```shell
PUBRT=$(aws ec2 describe-route-tables | jq -r -c '.RouteTables[]|{id: .RouteTableId, name: .Tags[0].Value}' | jq -r 'select(.name=="inspection-vpc/eu-west-1a/public-subnet-route-table")| .id')
TGWRT=$(aws ec2 describe-route-tables | jq -r -c '.RouteTables[]|{id: .RouteTableId, name: .Tags[0].Value}' | jq -r 'select(.name=="inspection-vpc/eu-west-1a/tgw-subnet-route-table")| .id')

TGWID=$(aws ec2 describe-transit-gateways | jq -r '.TransitGateways[]|select(.State == "available")|.TransitGatewayId')
NATGWID=$(aws ec2 describe-nat-gateways | jq -r '.NatGateways[]|select(.Tags[0].Value=="inspection-vpc/eu-west-1a/nat-gateway")| .NatGatewayId')

## without CP
aws ec2 delete-route --route-table-id $TGWRT --destination-cidr-block 0.0.0.0/0 
aws ec2 create-route --route-table-id $TGWRT --destination-cidr-block 0.0.0.0/0  --nat-gateway-id $NATGWID

aws ec2 delete-route --route-table-id $PUBRT --destination-cidr-block 10.0.0.0/8 
aws ec2 create-route --route-table-id $PUBRT --destination-cidr-block 10.0.0.0/8  --transit-gateway-id $TGWID
```
