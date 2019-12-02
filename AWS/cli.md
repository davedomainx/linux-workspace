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

== Images ==
Centos:

aws ec2 describe-images --owners aws-marketplace --filters 'Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce' --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output 'text'

aws ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce --query 'Images[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=CentOS Linux 7*"  --output table|sort -r

General:

for i in $(aws ec2 describe-images --owner self --query 'Images[*].{id:ImageId}' --output text); do aws ec2 describe-instances --filters "Name=image-id,Values=$i" ;done

aws ec2 describe-images --owner self --query 'Images[*].{id:ImageId}' --output text

aws ec2 describe-images --owners self --filters 'Name=name,Values=jenkins-qa-slave-windows-2008*' --query 'Images[*].{Name:Name,ImageId:ImageId}'

aws ec2 describe-images --image-ids ami-3548444c

aws ec2 deregister-image --image-id xxx --dry-run

== subnets ==

aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-99f836fc" --query 'Subnets[*].{VPC:VpcId,ID:SubnetId,IPs:CidrBlock}'

== Sorting ==

aws ec2 describe-images --owners self --filters 'Name=name,Values=jenkins-qa-slave-windows-*' |jq '.Images | sort_by(.CreationDate) | . [] | {Name: .Name, Created: .CreationDate, Id: .ImageId}'

== ssm ==

aws ssm start-automation-execution --document-name "AWSSupport-TroubleshootRDP" --parameters "InstanceId=XXX,Firewall=Disable" --region xxx

aws ssm start-automation-execution --document-name "AWSSupport-TroubleshootRDP" --parameters "InstanceId=XXX,RDPServiceStartupType=Auto, RDPServiceAction=Start" --region xxx

aws ssm start-automation-execution --document-name "AWSSupport-TroubleshootRDP" --parameters "InstanceId=xxx,RemoteConnections=Enable" --region xxx

# ERROR: recv: Connection reset by peer
aws ssm start-automation-execution --document-name "AWSSupport-TroubleshootRDP" --parameters "InstanceId=xxx,NLASettingAction=Disable"

#
aws ssm start-automation-execution --document-name "ManageRDPSettings" --parameters "InstanceId=INSTANCEID,RDPPortAction=Modify, RDPPort=3389, NLASettingAction=Disable,RemoteConnections=Enable"

== acm ==

aws acm describe-certificate --certificate xxx

== s3 ==

aws s3api list-buckets
aws s3 ls
