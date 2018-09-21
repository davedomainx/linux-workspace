terraform plan -out dave.plan
  # looks for files called something.tf and plans it
terrafor apply dave.plan

terraform state list
terraform state show libvirt_volume.base_image
