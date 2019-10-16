Ansible notes for network device (no remote python installed on network device)
===============================================================================

ansible-playbook -i hostsfile playbook.yml
ansible-playbook -vCD -i hostsfile playbook.yml # verbose, dry run, Diff
ansible-playbook --list-hosts ./fg-60e.yml

ansible-lint playbook.yml
ansible-playbook -i inventory --syntax-check --list-hosts playbook.yml

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

