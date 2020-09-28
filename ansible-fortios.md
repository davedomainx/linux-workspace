Install python3 + virtualenv on system

$ virtualenv -p /usr/bin/python3 ansible

Already using interpreter /usr/bin/python3
Using base prefix '/usr'
New python executable in /home/darnold/Virtualenv/ansible/bin/python3
Also creating executable in /home/darnold/Virtualenv/ansible/bin/python
Installing setuptools, pkg_resources, pip, wheel...done.

$ source ansible/bin/activate
$ pip install ansible fortiosapi netaddr

$ pip show ansible fortiosapi netaddr

#
# The below is required to install the pyFG module, which is required by some of the fortios_* modules, notably fortios_address (firewall management)

## NOTE : if using python3, you can just install pyFG like so:
## python -m pip install pip==9.0.3
## pip install pyFG

## Python 2.7 install
$ mkdir /tmp/pyfg && cd /tmp/pyfg
$ pip download pyfg && tar xpzf pyfg-0.50.tar.gz 
$ cd pyfg-0.50
# in setup.py, replace:
# from pip.req import parse_requirements
# with:
# try: # for pip >= 10
#    from pip._internal.req import parse_requirements
# except ImportError: # for pip <= 9.0.3
#    from pip.req import parse_requirements
$ python ./setup.py install
# ( installs into ./fortios/lib/python2.7/site-packages/pyfg-0.50-py2.7.egg )
$ pip list
$ pip show pyfg
$ pip list
$ pip download pyFG
 (will bomb out but download it okay
