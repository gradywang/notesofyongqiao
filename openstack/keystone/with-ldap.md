## Keystone with LDAP

### Deploy LDAP for Keystone
Refer the [offical document](https://wiki.openstack.org/wiki/OpenLDAP) for the details.

Main steps on Ubuntu as below:
```
# sudo apt-get install -y slapd ldap-utils
# sudo dpkg-reconfigure slapd
Omit OpenLDAP server configuration? No
DNS Domain Name: ibm.com
Organization name: cfc
Database backend to use: HBD
Do you want the database to be removed when slapd is purged? Yes
Move old database? Yes
Allow LDAPv2 protocol? Yes
```
Verification: 
```
# ldapsearch -x -W -D"cn=admin,dc=ibm,dc=com" -b dc=ibm,dc=com }}
Enter LDAP Password:
# extended LDIF
#
# LDAPv3
# base <dc=ibm,dc=com> with scope subtree
# filter: (objectclass=*)
# requesting: }}
#

# ibm.com
dn: dc=ibm,dc=com

# admin, ibm.com
dn: cn=admin,dc=ibm,dc=com

# search result
search: 2
result: 0 Success

# numResponses: 3
# numEntries: 2
```

Initialize the LDAP for Keystone
```
# cat /tmp/keystoneldapinit.ldif
dn: ou=Groups,dc=ibm,dc=com
objectClass: top
objectClass: organizationalUnit
ou: groups

dn: ou=Users,dc=ibm,dc=com
objectClass: top
objectClass: organizationalUnit
ou: users

# ldapadd -x -W -D"cn=admin,dc=ibm,dc=com" -f /tmp/keystoneldapinit.ldif
Enter LDAP Password:
adding new entry "ou=Groups,dc=ibm,dc=com"

adding new entry "ou=Users,dc=ibm,dc=com"

# ldapsearch -x -W -D"cn=admin,dc=ibm,dc=com" -b dc=ibm,dc=com
Enter LDAP Password:
# extended LDIF
#
# LDAPv3
# base <dc=ibm,dc=com> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# ibm.com
dn: dc=ibm,dc=com
objectClass: top
objectClass: dcObject
objectClass: organization
o: cfc
dc: ibm

# admin, ibm.com
dn: cn=admin,dc=ibm,dc=com
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: e1NTSEF9R0pmZUgwTFRmMXR1NzRTQlFNbWVDWitBUmlTNndvL2o=

# Groups, ibm.com
dn: ou=Groups,dc=ibm,dc=com
objectClass: top
objectClass: organizationalUnit
ou: groups

# Users, ibm.com
dn: ou=Users,dc=ibm,dc=com
objectClass: top
objectClass: organizationalUnit
ou: users

# search result
search: 2
result: 0 Success

# numResponses: 5
# numEntries: 4
```

### [Install Keystone](http://docs.openstack.org/developer/keystone/installing.html)
```
# export LANGUAGE=en_US.UTF-8 
# export LANG=en_US.UTF-8 
# export LC_ALL=en_US.UTF-8 
# locale-gen en_US.UTF-8 dpkg-reconfigure locales
# sudo apt-get install -y keystone
# apt-get install -y policycoreutils
# setsebool -P authlogin_nsswitch_use_ldap on

# export ENDPOINT=9.21.63.177
# export SERVICE_TOKEN=ADMIN
# export SERVICE_ENDPOINT=http://${ENDPOINT}:35357/v2.0
# keystone user-list
vim /etc/keystone.conf

 

[DEFAULT]

admin_token=ae3b19ba29ee81a66b3a

verbose = true

log_dir = /var/log/keystone

# curl -H "X-Auth-Token:ADMIN" http://localhost:35357/v2.0/tenants/admin/users | python -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    13  100    13    0     0    555      0 --:--:-- --:--:-- --:--:--   565
{
    "users": []
}

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_AUTH_URL=http://9.21.63.177:35357/v2.0
export OS_IDENTITY_API_VERSION=2.0
export OS_IMAGE_API_VERSION=2
```

```
ldapsearch -x -W -D"cn=admin,dc=ibm,dc=com" -b dc=ibm,dc=com
```

### Configure Keystone with LDAP driver

