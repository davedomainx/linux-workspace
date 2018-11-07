http://jmespath.org/specification.html

1. aws ec2 describe.. |head -20
	top level is the 'root-level-key' to iterate over
	then do Name:Key to filter out what you want
	--query 'root-level-key[*].{VPC:VpcId,Subnet:SubnetId}'

2. aws ec2 describe-images --owners self --filters 'Name=name,Values=jenkins-qa-slave-windows-2008*'|head -20
Shows 'Images' as the toplevel, so I iterate over it like so:
'Images[*].{Name:Name,ImageId:ImageId}'

=====================================

aws ec2 describe-instances
aws ec2 describe-snapshots --query 'Snapshots[*].{Desc:Description,Owner:OwnerId,ID:SnapshotId}'

aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, Tags[?Key==`Name`].Value | [0]]'

aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId, Tags]" --output text | grep None | awk '{print $1}'

aws ec2 describe-instances --query 'Reservations[].Instances[].{Name: Tags[?Key==`Name`].Value | [0], Role: Tags[?Key==`Billing by Role`].Value | [0]}' --output text

aws ec2 describe-instances --instance-id <instance> --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text
rdesktop -g 1440x900 -P -z -x l -r sound:off -u vagrant <IP above>:3389

== C7 images ==

aws ec2 describe-images --owners aws-marketplace --filters 'Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce' --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output 'text'

aws ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce --query 'Images[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=CentOS Linux 7*"  --output table|sort -r

== images ==

aws ec2 describe-images --owners self --filters 'Name=name,Values=jenkins-qa-slave-windows-2008*' --query 'Images[*].{Name:Name,ImageId:ImageId}'

== subnets ==

aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-99f836fc" --query 'Subnets[*].{VPC:VpcId,ID:SubnetId,IPs:CidrBlock}'


== Sorting ==

aws ec2 describe-images --owners self --filters 'Name=name,Values=jenkins-qa-slave-windows-*' |jq '.Images | sort_by(.CreationDate) | . [] | {Name: .Name, Created: .CreationDate, Id: .ImageId}'
