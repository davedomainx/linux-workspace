ansible itvm -m setup -i inventory

ansible_user in inventory file, not 'user'

copy module files to toplevel "modules/" directory
--module_path=./modules

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

