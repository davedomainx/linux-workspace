Ansible notes for network device (no remote python installed on network device)
===============================================================================

default client ip is 192.168.1.110

reset fg60e : power on, wait for status led to blink (1 min), press+hold reset button - will flash
fast green for 5 secs then stop. Release button.  Takes 2 minutes to boot.

install ansible v2.8 in venv (see internal docco)
in venv, pip install fortiosapi 

ansible fortios* modules seem to be incredibly sensitive to the slightest typo
and/or if it was created by ansible ..

SEEMS THAT HAVE TO DELETE manually from the fortigate if entry present
	the dreaded "msg: Error in Repo" ..

===
modules

have to hunt through the ansible fortios* modules to find the ones that are relevant/needed
these ansible modules are interesting/relevant:

fortios_system_admin
	configure admin users

fortios_system_interface
	configure physical/vlan/wan interfaces

fortios_system_global
	configure global settings

fortios_system_dhcp_server
	configure dhcp servers on [vlan] interfaces

fortios_address
	configure firewall addresses
		so much trouble with this one ..

  "msg": "Unsupported parameters for (fortios_address) module: fortios_address, https Supported parameters include: backup, backup_filename, backup_path, comment, config_file, country, end_ip, file_mode, host, interface, name, password, start_ip, state, timeout, type, username, value, vdom"

		pip install netaddr : no diff
	
order of attributes in the yml seems to be important (case-ordered  .... )

no custom devices possible thru foritos modules ?


===
create a cleartext file outside of the repo that contains the password of the 
ansible vault that you'll use to create an encrypted string

echo -n "stringtoencrypt" | ansible-vault encrypt_string
< enter the ansible vault password when prompted >
# you have to use -n otherwise it seems that newline gets appended to the encrypted string

ansible-playbook -i hostsfile playbook.yml --vault-password-file ~/thisfile
ansible-playbook --list-hosts ./fg-60e.yml

ansible-lint playbook.yml
ansible-playbook -i inventory --syntax-check --list-hosts playbook.yml

ansible all -m setup -i inventory -u username -a "filter=*distribution"

ansible -m ping all -vvv -i ./inventory -u username

ansible all -m setup -i inventory -u username --tree /tmp/factsx

=== initial bootstrap config
# need to connect first to remote device to do initial bootstrap config
ansible -i inventory  -m ping all -u admin --ask-pass

ansible-playbook -vCD -i inventory -u admin --ask-pass playbook.yml # verbose, check (dry run), Diff

# note that check/dry-run not supported on network devices (no remote python on network devices)

# complains no python interpreter at remote end
# https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html
# need to tell ansible to not run remote interpreter

https://docs.ansible.com/ansible/2.5/network/getting_started/network_differences.html

# https://www.reddit.com/r/ansible/comments/cr9i5l/anyone_successfully_using_ansible_28_and_new/

need to set some info in tryme.yml:
---
  - name: Setup Privileged Users on Fortigate
    hosts: localhost
    gather_facts: no
    connection: local

ansible-playbook -vD -i ./inventory -u admin --ask-pass ./tryme.yml

fails : ansible keeps saying that fortiosapi module needs to be installed ..

ansible-doc fortios_system_admin # works fine
pydoc modules|grep -i fortiosapi # it's there

aha : ansible defaults to a builtin interpreter (/usr/bin/python) when running in 'local' mode ..

https://stackoverflow.com/questions/51971865/ansible-doesnt-see-an-installed-python-module
https://github.com/ansible/ansible/issues/42152#issuecomment-403298207
http://willthames.github.io/2018/07/01/connection-local-vs-delegate_to-localhost.html

FIXED with in inventory/hosts file
localhost ansible_python_interpreter=/home/darnold/<full path to virtualenv python>

===
fix broken HTTP verification: 
# https://www.reddit.com/r/ansible/comments/cr9i5l/anyone_successfully_using_ansible_28_and_new/

venv -> lib/python2.7/site-packages/fortiosapi/fortiosapi.py:

    Open file:
        fortiosapi.py
        E.g. : /usr/lib/python2.7/site-packages/fortiosapi/fortiosapi.py
    Go to line 171:
        data='username=' + urllib.parse.quote(username) + '&secretkey=' + urllib.parse.quote(password) + "&ajax=1", timeout=self.timeout)
    Add ", verify=False" to the end of those parameters:
        E.g:
        data='username=' + urllib.parse.quote(username) + '&secretkey=' + urllib.parse.quote(password) + "&ajax=1", timeout=self.timeout, verify=False)

===

unsecured https not allowed
fixed - https on fortigate was set to non-443 port

===

fortios_system_admin
	bug in the fortios_system_admin module if entry/attribute already exists
	https://github.com/fortinet-solutions-cse/ansible_fgt_modules/issues/10

	if entry/attribute already exists, any subsequent run will fail
	so have to "run_once" ...

===
NOTE : username is case sensitive !!!
===
FG-60E specific:
MUST take out the 'LAN' port out of the internal hardware switch seperately ...
https://www.sysprobs.com/how-to-change-switch-mode-to-interface-mode-in-fortigate-fortios-5

fortios_system_interface

sigh..
fg-60e
***
take internal2 out of the existing hardware switch ? <<< dont know if I need to do this ..
***
internal2:
 ip 192.. /255 ..
 type: physical
 role: lan
 vdom: root
 allowaccess ping https ssh

===

I seem to need to break up each task into seperate yml files ..

create_admin ..
create_interface ..
create_vlan ..

===
fortios_system_global

need to review these settings:

sslvpn-cipher-hardware-acceleration
strong-crypto
timezone
	set timezone ?
	set timezone 25
traffic-priority
traffic-priority-level


===
fortios_system_dhcp_server

default-gateway: needs to be present ... when set to the VLAN default gw, it shows up in FG as "same as interface IP"
