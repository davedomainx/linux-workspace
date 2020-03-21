terraform init
terraform plan -out dave.plan
terraform apply dave.plan

terraform state list
terraform state show libvirt_volume.base_image

# terraform seems to require region set in variables.tf, and referred to in main.tf
# otherwise you get promted for region

# Ubuntu https://cloud-images.ubuntu.com/locator/ec2/
ami-07042e91d04b1c30d

# Transit Gateway https://medium.com/@devopslearning/21-days-of-aws-using-terraform-day-14-introduction-to-transit-gateway-using-terraform-8bbc3ce00b4c
Although Transit Gateway in AWS is under 'VPC', all the code/docco/cli has 
'ec2' in the name, quite confusing ..

aws ec2 describe-transit-gateway-attachments

# terraform will not destroy resources it does not explictly manage
# this is obviously great news as you can hardcode existing infra in .tf files
# and not have to worry about clobbering your existin infra

# Route table creation timeout issues..
https://www.reddit.com/r/Terraform/comments/cqm9kn/adding_multiple_routes_to_route_table/

# Hm, I seem to have added a completely new TGW Route Table
# I wanted to only add a route to the existing TGW Route table ..
# problem is here:
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rta" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa.id
}
# need to use the existing TGW route table, so it needs to be:
resource "aws_ec2_transit_gateway_route_table_association" "tgw_rta" {
  transit_gateway_route_table_id = "tgw-rtb-058790b0e8a085527"
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgwa.id
}

# it looks like two route table entries are being created for some reason
# one is 'Main = yes'
# the other is 'Main = no'

Tried a few things but routing not correctly setup.
okay, seems allowing default behaviour for aws_ec2_transit_gateway_vpc_attachment
with 
# transit_gateway_default_route_table_association = false
# transit_gateway_default_route_table_propagation = false

Now all i need is to add a default route back to the TGW from the new RT ..
Trying aws_default_route_table
