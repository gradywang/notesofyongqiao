## Keystone with LDAP

### Deploy LDAP for Keystone
Refer the [offical document](https://wiki.openstack.org/wiki/OpenLDAP) for the details.

Main steps on Centos 7 as below:
```
# yum list | grep openldap-servers
Failed to set locale, defaulting to C
openldap-servers.x86_64                    2.4.40-9.el7_2              @updates
openldap-servers-sql.x86_64                2.4.40-9.el7_2              updates
# yum install openldap-servers.x86_64
# service slapd start
Redirecting to /bin/systemctl start  slapd.service
```

Decide on a root password and hash it by running:
```
# slappasswd -h {SSHA} -s Letmein123
{SSHA}YZOSuKzHQy1WpdmsIe6LFMIAAHBB+19q
```
Now create a file named manager.ldif like this:
```
# cat /tmp/manager.ldif
dn:  olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=ibm,dc=org
-
replace: olcRootDN
olcRootDN: dc=cwc,dc=ibm,dc=org
-
add: olcRootPW
olcRootPW: {SSHA}YZOSuKzHQy1WpdmsIe6LFMIAAHBB+19q
```

Now configure your Open LDAP server by running:
```
# ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/manager.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={2}hdb,cn=config"
```
