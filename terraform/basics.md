libvirt provider
================
https://github.com/dmacvicar/terraform-provider-libvirt/issues/272

. bug with libvirt provider-dhcp incorrectly setting static IP address: need to ifdown/ifup eth0 + restart network in cloud init to set IP address properly/statically

. if using count, need to declare it in each resource type
