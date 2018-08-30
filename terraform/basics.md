libvirt provider
================
https://github.com/dmacvicar/terraform-provider-libvirt/issues/272

. bug with libvirt provider-dhcp incorrectly setting static IP address: need to ifdown/ifup eth0 + restart network in cloud init to set IP address properly/statically.

. bug above actually seems to be in cloudinit; something is intercepting terraforms dhcp setup

. if using count, need to declare it in each resource type

. sometimes terraform gets into a state - delete the tfstate file - dangerous!
