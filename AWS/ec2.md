```
aws ec2 describe-instances
aws ec2 describe-snapshots --query 'Snapshots[*].{Desc:Description,Owner:OwnerId,ID:SnapshotId}'
```

