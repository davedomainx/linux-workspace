Ansible has terrible/nonexisting testing of roles.  
--syntax-check and check are for playbooks, not roles.

Seems that molecule is the way to go for role testing

# https://austincloud.guru/2018/09/18/adding-a-molecule-to-an-existing-ansible-role/
# https://www.jeffgeerling.com/blog/2018/testing-your-ansible-roles-molecule
# https://www.toptechskills.com/ansible-tutorials-courses/rapidly-build-test-ansible-roles-molecule-docker/
# https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjcwcHi4IvsAhX0oFwKHZraBLUQFjAGegQICRAB&url=https%3A%2F%2Fwww.adictosaltrabajo.com%2F2020%2F05%2F08%2Fansible-testing-using-molecule-with-ansible-as-verifier%2F&usg=AOvVaw2sO3CLjhxhWXMVP3QR0vVk
# https://redhatnordicssa.github.io/how-we-test-our-roles
# https://digitalis.io/blog/using-molecule-to-test-ansible-roles/

Pre-reqs:
--------
docker # ubuntu 20.04
  sudo apt install docker.io
  sudo systemctl enable --now docker
  sudo usermod -aG docker username
  docker --version
pip3 install molecule
pip3 install 'molecule[docker,lint]'
pip3 install docker # unsure if required
reboot # sanity

Existing single role (mariadb)
------------------------------
cd mariadb
# setup molecule in existing role (you must be inside the "mariadb" role)
# molecule init scenario -r mariadb -d docker # setup molecule in existing role
molecule init scenario -r mariadb -d docker
molecule init scenario --role-name ant --driver-name docker

Replace initial molecule docker image with geerlingguy:
molecule/default/molecule.yml:
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: instance
    image: "geerlingguy/docker-${MOLECULE_DISTRO:-centos7}-ansible:latest"
    command: ${MOLECULE_DOCKER_COMMAND:-""}
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    pre_build_image: true
provisioner:
  name: ansible
  env:
    ANSIBLE_ROLES_PATH: "../../roles" # this is the important one to correctly locate the roles dir
verifier:
  name: ansible

# Now can start building/testing

molecule lint # simple linter to ensure everything setup

molecule create # creates the docker instance for testing

molecule converge # rapid testing, re-uses the docker instance

molecule test # full scale testing

moleclue destroy # destroys the docker instance

systemd/services testing
------------------------
Default molecule docker images do not support systemd/services
testing, so have to use a systemd enabled docker container (geerlingguy)

change platform in molecule.yml:
platforms:
  - name: instance
    image: "geerlingguy/docker-${MOLECULE_DISTRO:-centos7}-ansible:latest"
    command: ${MOLECULE_DOCKER_COMMAND:-""}
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    pre_build_image: true

Pull in dependant existing roles
--------------------------------

roles/directories/tasks/main.yml

.. From this playbook in another role ..
roles/mariadb/molecule/default/converge.yml:

---
- name: Converge
  hosts: all
  gather_facts: false
  vars:
    set_dummy_var: somevar # temporarily set a variable to pass molecule
  roles:
     - directories
  tasks:
    - include_role:
        name: directories

running 'molecule converge' will pull in the 'directories' role

-------------------------

toplevel 
  molecule/
  roles/

https://stackoverflow.com/questions/61856958/molecule-test-roles-from-other-directory
https://github.com/ansible-community/molecule/issues/1093
