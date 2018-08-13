#### AWS basics

* https://www.reddit.com/r/sysadmin/comments/8inzn5/so_you_want_to_learn_aws_aka_how_do_i_learn_to_be/
* https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
* https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
* https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html
* https://docs.aws.amazon.com/cli/latest/userguide/controlling-output.html

* https://wblinks.com/notes/aws-tips-i-wish-id-known-before-i-started/
* https://linuxacademy.com/blog/amazon-web-services-2/troubleshooting-ec2-connectivity-issues/

#### AWS Root account

* https://docs.aws.amazon.com/general/latest/gr/aws_tasks-that-require-root.html

#### AWS CLI setpu

```
pip install awscli [[–user]] ; mkdir ~/.aws; cd .aws ; [[ aws configure ; cp the credentials file here .. ]]
export AWS_PROFILE=account
unset http_proxy https_proxy HTTPS_PROXY HTTP_PROXY AWS_DEFAULT_PROFILE
aws ec2 describe-regions --output table
echo -e "[profile account]\nregion = from_above" >> config
```