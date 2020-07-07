Careful when using an ARN that has multiple conflicting
policies attached, seems that terraform uses the first 
or most restrictive policy it comes across, which prevents
orderly execution of the plan ..

Terraform modules is slightly confusing..
. need to define initial empty variables, then reference them later .. ?

Good explanation of how to split up monolithic structure
https://learn.hashicorp.com/terraform/modules/tf-code-management
. workspace or directory

