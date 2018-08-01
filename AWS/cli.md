aws ec2 describe-instances
aws ec2 describe-snapshots --query 'Snapshots[*].{Desc:Description,Owner:OwnerId,ID:SnapshotId}'

aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, Tags[?Key==`Name`].Value | [0]]'

aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId, Tags]" --output text | grep None | awk '{print $1}'

aws ec2 describe-instances --query 'Reservations[].Instances[].{Name: Tags[?Key==`Name`].Value | [0], Role: Tags[?Key==`Billing by Role`].Value | [0]}' --output text

aws ec2 describe-instances --instance-id <instance> --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text


