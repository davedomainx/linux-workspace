Ansible has terrible/nonexisting testing of roles.  
--syntax-check and check are for playbooks, not roles.

Seems that molecule is the way to go for role testing

# https://austincloud.guru/2018/09/18/adding-a-molecule-to-an-existing-ansible-role/
# https://www.jeffgeerling.com/blog/2018/testing-your-ansible-roles-molecule

Pre-reqs:
--------
docker # ubuntu 20.04
  sudo apt install docker.io
  sudo systemctl enable --now docker
  sudo usermod -aG docker username
  docker --version
pip3 install molecule
pip3 install docker

Existing role (mariadb)
-----------------------
cd mariadb
molecule init scenario -r mariadb -d docker
molecule lint
molecule create
