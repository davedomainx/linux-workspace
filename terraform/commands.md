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
