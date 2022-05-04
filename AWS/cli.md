http://jmespath.org/specification.html

1. aws ec2 describe.. |head -20
	top level is the 'root-level-key' to iterate over
	then do Name:Key to filter out what you want
	--query 'root-level-key[*].{VPC:VpcId,Subnet:SubnetId}'

2. aws ec2 describe-images --owners self --filters 'Name=name,Values=jenkins-qa-slave-windows-2008*'|head -20
Shows 'Images' as the toplevel, so I iterate over it like so:
'Images[*].{Name:Name,ImageId:ImageId}'

=====================================
# Find resources not tagged with specific key
aws resourcegroupstaggingapi get-resources --tags-per-page 100 | jq '.ResourceTagMappingList[] | select(contains({Tags: [{Key: "map-migrated"} ]}) | not)'
=====================================

aws ec2 describe-tags --filters "Name=resource-id,Values=instance_id

aws ec2 describe-instances
aws ec2 describe-snapshots --query 'Snapshots[*].{Desc:Description,Owner:OwnerId,ID:SnapshotId}'

aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId, Tags[?Key==`Name`].Value | [0]]'

aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId, Tags]" --output text | grep None | awk '{print $1}'

aws ec2 describe-instances --query 'Reservations[].Instances[].{Name: Tags[?Key==`Name`].Value | [0], Role: Tags[?Key==`Billing by Role`].Value | [0]}' --output text

aws ec2 describe-instances --instance-id <instance> --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text
rdesktop -g 1440x900 -P -z -x l -r sound:off -u vagrant <IP above>:3389

== Images ==

Multiple values

aws ec2 describe-images --owners self --filter "Name=name,Values=eng-*,dev-*,jenkins-mc*,jarvis-*" |jq '.Images | sort_by(.CreationDate) | . [] | {Name: .Name, Id: .ImageId, Created: .CreationDate}'

aws ec2 describe-images --owners self --filter "Name=name,Values=eng-*,dev-*" |jq '.Images | sort
_by(.CreationDate) | . [] | {Name: .Name, Created: .CreationDate, Id: .ImageId}'

Centos:

aws ec2 describe-images --owners aws-marketplace --filters 'Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce' --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output 'text'

aws ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce --query 'Images[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=CentOS Linux 7*"  --output table|sort -r

aws ec2 describe-images --owners aws-marketplace --filters Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce --query 'Images[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=CentOS Linux 6*"  --output table|sort -r

# New CentOS direct-publishing
aws ec2 describe-images --owners 125523088429  --filters "Name=name,Values=CentOS*"

# Volumes - change termination properties
aws ec2 modify-instance-attribute --instance-id i-XXX --block-device-mappings "[{\"DeviceName\": \ "/dev/sdf\",\"Ebs\":{\"DeleteOnTermination\":false}}]"
# no output, but it suceeded. refreshing the instance page/storage in AWS should show the volume is marked
# for termination - Ah and it now also does not warn you about lingering storage/volumes ....

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

== user data ==

aws ec2 describe-instance-attribute --instance-id i-xxx --attribute userData --output text --query "UserData.Value" | base64 --decode
aws ec2 get-console-output --instance-id i-xxx

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
time aws s3 rm s3://bucket_name --dryrun --recursive --exclude "*" --include "Oct24-accesslogging2018-10-25*"

== Security Groups ==

# revoking those awful nested secgroups ..

aws ec2 delete-security-group --group-id=sg-a09689c7

An error occurred (DependencyViolation) when calling the DeleteSecurityGroup operation: resource sg-a09689c7 has a dependent object

> aws ec2 describe-security-groups --group-id=sg-a09689c7
{
    "SecurityGroups": [
        {
            "Description": "web-services-elasticache",
            "GroupName": "web-services-elasticache",
            "IpPermissions": [],
            "OwnerId": "XXX",
            "GroupId": "sg-a09689c7",
            "IpPermissionsEgress": [
                {
                    "IpProtocol": "-1",
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": [],
                    "UserIdGroupPairs": []
                }
            ],
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "web-services-elasticache"
                }
            ],
            "VpcId": "vpc-xxxx"
        }
    ]
}


# delete ingress and egress entries
aws ec2 revoke-security-group-ingress --group-id sg-a09689c7 --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 0, "ToPort": 65535, "UserIdGroupPairs": [{"GroupId": "sg-b6038dd3","UserId": "XXXXX"}]}]'

 aws ec2 revoke-security-group-egress --group-id sg-a09689c7 --ip-permissions '[{"IpProtocol": "-1", "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'

> aws ec2 describe-security-groups --group-id=sg-a09689c7
{
    "SecurityGroups": [
        {
            "Description": "web-services-elasticache",
            "GroupName": "web-services-elasticache",
            "IpPermissions": [],
            "OwnerId": "379066572991",
            "GroupId": "sg-a09689c7",
            "IpPermissionsEgress": [],
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "web-services-elasticache"
                }
            ],
            "VpcId": "vpc-99f836fc"
        }
    ]
}

Turns out there was an elasticache interface with the SecurityGroupsaattached.  Deleting the elasticache cluster and then deleting
the security group works now:

aws ec2 describe-security-groups --filters Name=vpc-id,Values=vpc-xxxx --query "SecurityGroups[*].{Name:GroupName,Group:GroupId,Desc:Description}"

== rds ==

aws rds modify-db-instance --no-deletion-protection --db-instance-identifier <db-name>

aws rds delete-db-instance --db-instance-identifier <db-name> --final-db-snapshot-identifier <db-name>-last

# this seems to fail if a snapshot is actively being generated ..
aws rds describe-db-snapshots --query="reverse(sort_by(DBSnapshots, &SnapshotCreateTime))"

== IAM ==

> aws accessanalyzer list-analyzers --query 'analyzers[*].arn'
[
    "arn:aws:access-analyzer:eu-central-1:XXX:analyzer/ConsoleAnalyzer-2b73dde5-0b52-4e17-a0fb-f908ad06444b"

]
> aws accessanalyzer list-findings --analyzer-arn arn:aws:access-analyzer:eu-central-1:XXX:analyzer/ConsoleAnalyzer-2b73dde5-0b52-4e17-a0fb-f908ad06444b
{
    "findings": []

}

