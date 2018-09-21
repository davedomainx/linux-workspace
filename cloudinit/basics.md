https://www.zetta.io/en/help/articles-tutorials/cloud-init-reference/

# useful cloudinit stanza
resource "libvirt_cloudinit" "commoninit" {
          count = "${var.count}"
          name = "${lookup(var.hostnames,count.index)}_cloud"
          local_hostname = "${lookup(var.hostnames,count.index)}"
          pool = "default" #CHANGEME
          ssh_authorized_key = ....
          user_data = <<EOF
#cloud-config
write_files:
  - path: /etc/sysconfig/network-scripts/ifcfg-eth0
    content: |
      DEVICE="eth0"
      BOOTPROTO="none"
      ONBOOT="yes"
      TYPE="Ethernet"
      USERCTL="yes"
      IPADDR="10.0.12.${count.index + 100}"
      NETMASK="255.255.255.0"
      GATEWAY="10.0.12.1"
runcmd:
  - ifdown eth0; ifup eth0
users:
  - name: xxxxx
    password: $6$....
    lock-password: false
    ssh_authorized_keys:
      - ssh-ed25519 .....
    sudo: ['ALL=(ALL) ALL']
EOF
}
