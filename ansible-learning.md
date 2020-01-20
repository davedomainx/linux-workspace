https://sites.google.com/site/mrxpalmeiras/ansible/ansible-cheat-sheet?tmpl=%2Fsystem%2Fapp%2Ftemplates%2Fprint%2F&showPrintDialog=1

ansible itvm -m setup -i inventory

ansible -m ping -i inventory somehostgroup --private-key=~/.ssh/xxx -u yyy

# dump remote facts into /tmp/remotefacts/<hostname>
ansible -i inventory -m setup --tree /tmp/remotefacts/

facter ansible module ( no easy way to tell if machine is physical/virtual .. )

ansible_user in inventory file, not 'user'

- name: Include Main Firewall playbook
  include: roles/firewall/tasks/main.yml

If you ever get the below error with iptables_raw,
then it cannot find/locate the playbook and/or the
iptables_raw.py file ...



copy module files to toplevel "library/" directory
-or-
specify following option, but doesnt seem to work reliably..
--module_path=./modules

ansible -m debug -a 'msg={{ lookup("config", "DEFAULT_MODULE_PATH")}}' localhost

iptables_raw: 
# Open TCP port 22, but insert it before port 80 (default weight is 40)
- iptables_raw:
    name: allow_tcp_22
    rules: '-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT'
    weight: 35

Note very strange behaviour with command/shell + grep
	need register, ignore_errors: yes, and failed_when ..

using register seems to 'mask' the expected output of a run/variable

These are the same;
- debug:
      msg: "{{ sssd_already_configured }}"

  - debug:
      var: sssd_already_configured

https://medium.com/design-and-tech-co/end-to-end-automated-environment-with-vagrant-ansible-docker-jenkins-and-gitlab-32bb91fbee40

== Check for and disable services ==

- name: Get Service Facts
  service_facts:

 - name: "Disable unwanted services"
    service:
 _    name: "{{ item }}"
      enabled: no
+     state: stopped
+   loop : "{{ disabled_services }}"
+   when:
+     - "{{ item in ansible_facts.services }}"
+     - "ansible_facts.services.{{ item }}.state == 'running'"

