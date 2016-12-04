Cloud Admin and Domain Admin
https://www.rdoproject.org/documentation/domains/

# Keystone V3 API
export KEYSTONE_SERVER=192.168.56.103

## Get get the domain-scoped token of cloud administrator
```
# OS_TOKEN=$(\
curl http://${KEYSTONE_SERVER}:5000/v3/auth/tokens \
    -s \
    -i \
    -H "Content-Type: application/json" \
    -d '
{
    "auth": {
        "identity": {
            "methods": [
                "password"
            ],
            "password": {
                "user": {
                    "domain": {
                        "name": "default"
                    },
                    "name": "admin",
                    "password": "Letmein123"
                }
            }
        },
        "scope": {
            "domain": {
                "name": "default"
            }
        }
    }
}' | grep ^X-Subject-Token: | awk '{print $2}' ) ; echo $OS_TOKEN
MIIDbgYJKoZIhvcNAQcCoIIDXzCCA1sCAQExDTALBglghkgBZQMEAgEwggG8BgkqhkiG9w0BBwGgggGtBIIBqXsidG9rZW4iOnsiZG9tYWluIjp7ImlkIjoiNzc4YzliNGYyMTcxNGM5YWIwMDlmZTZkMjg5OTZjOTMiLCJuYW1lIjoiZGVmYXVsdCJ9LCJtZXRob2RzIjpbInBhc3N3b3JkIl0sInJvbGVzIjpbeyJpZCI6ImUxMzdlN2UwMmRmNDQ0ZTliMDNhNWQyYTAxMTM0NmVmIiwibmFtZSI6ImFkbWluIn1dLCJleHBpcmVzX2F0IjoiMjAxNi0xMi0wNFQwMzo0MjozNS4yMzcyNTVaIiwidXNlciI6eyJkb21haW4iOnsiaWQiOiI3NzhjOWI0ZjIxNzE0YzlhYjAwOWZlNmQyODk5NmM5MyIsIm5hbWUiOiJkZWZhdWx0In0sImlkIjoiYjE5NDhiYjNmNzgzNDVmYTk2MWQwNGVlMTI1NTRmNmUiLCJuYW1lIjoiYWRtaW4ifSwiYXVkaXRfaWRzIjpbIlV1NHVKb2taUkRHMTRFRmYwTElrNXciXSwiaXNzdWVkX2F0IjoiMjAxNi0xMi0wNFQwMjo0MjozNS4yMzcyNzZaIn19MYIBhTCCAYECAQEwXDBXMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVW5zZXQxDjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tAgEBMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCX6ifq6uMx2PDt6IdM2whRRRgwVU+WgqvWroLECrp1+g9dkFbhiw7QmH3KuNWEREmpsjz5jbcv-7MwBQ-oP-oe+rb9ez-w4ij4fv9XOoTIszBpDis1FH2GPkqoZOJeTUjZUaUT71rC8BCERmG0OB87Qv8WWxSQBhQuT7WxX7lhtUo3cUVcxVirqj8DmBK6uDCpumGKYXChYcWnz1qCFhgZY-XOwFzRyLmj9SiSxF2l8GJyQ7MgMXRtZnCpQLasYFdVHUzXWpCgVv8fGaxWbW814THT+nIEo7b05kWH5OqG0+Fiot6q+bsmMWPtgS-P7J86xLFzgmIhNte4UAV8zYc+
```

## List users 
云管理员可以查询到所有的用户（包括管理域和租户域的）
```
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/users | python -m json.tool
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://192.168.56.101:5000/v3/users"
    },
    "users": [
        {
            "domain_id": "d15390a0fee3414c8d78d8a78f65447c",
            "enabled": true,
            "id": "b8220db4be9c4d3997a89d19e586edee",
            "links": {
                "self": "http://192.168.56.101:5000/v3/users/b8220db4be9c4d3997a89d19e586edee"
            },
            "name": "admin"
        }
    ]
}
```

## List roles
```
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/roles | python -m json.tool
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://192.168.56.101:5000/v3/roles"
    },
    "roles": [
        {
            "domain_id": null,
            "id": "e137e7e02df444e9b03a5d2a011346ef",
            "links": {
                "self": "http://192.168.56.101:5000/v3/roles/e137e7e02df444e9b03a5d2a011346ef"
            },
            "name": "admin"
        }
    ]
}
```

## List domians
```
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/domains | python -m json.tool
{
    "domains": [
        {
            "description": "Cloud Admin Domain",
            "enabled": true,
            "id": "778c9b4f21714c9ab009fe6d28996c93",
            "links": {
                "self": "http://192.168.56.101:5000/v3/domains/778c9b4f21714c9ab009fe6d28996c93"
            },
            "name": "default"
        }
    ],
    "links": {
        "next": null,
        "previous": null,
        "self": "http://192.168.56.101:5000/v3/domains"
    }
}
```

## Create a telnet domain
```
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "domain": {
        "name": "telnet1", 
        "description": "Telnet Domain description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/domains | python -mjson.tool
{
    "domain": {
        "description": "Telnet Domain description",
        "enabled": true,
        "id": "8232eff82826442799ea34776c79899e",
        "links": {
            "self": "http://192.168.56.101:5000/v3/domains/8232eff82826442799ea34776c79899e"
        },
        "name": "telnet1"
    }
}
```

## Create the admin user for telnet 
```
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "user": {
        "domain_id": "8232eff82826442799ea34776c79899e", 
        "name": "telnetAdmin", 
        "password": "Letmein123", 
        "email": "telnetAdmin@huawei.com",
        "description": "Telnet Admin User description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/users | python -mjson.tool
{
    "user": {
        "description": "Telnet Admin User description",
        "domain_id": "8232eff82826442799ea34776c79899e",
        "email": "telnet1@huawei.com",
        "enabled": true,
        "id": "573ff0a2e1af41bb8f405a536a0dd4cc",
        "links": {
            "self": "http://192.168.56.101:5000/v3/users/573ff0a2e1af41bb8f405a536a0dd4cc"
        },
        "name": "telnetAdmin"
    }
}
```

## Assign telnet admin user to telnet domain with admin role
```
#　curl -i -X "PUT" -H "X-Auth-Token: $OS_TOKEN" http://${KEYSTONE_SERVER}:5000/v3/domains/8232eff82826442799ea34776c79899e/users/573ff0a2e1af41bb8f405a536a0dd4cc/roles/e137e7e02df444e9b03a5d2a011346ef
```

## Get get the domain-scoped token of telnet administrator
```
# OS_TOKEN=$(\
curl http://${KEYSTONE_SERVER}:5000/v3/auth/tokens?nocatalog  \
    -s \
    -i \
    -H "Content-Type: application/json" \
    -d '
{
    "auth": {
        "identity": {
            "methods": [
                "password"
            ],
            "password": {
                "user": {
                    "domain": {
                        "name": "telnet1"
                    },
                    "name": "telnetAdmin",
                    "password": "Letmein123"
                }
            }
        },
        "scope": {
            "domain": {
                "name": "telnet1"
            }
        }
    }
}' | grep ^X-Subject-Token: | awk '{print $2}' ); echo $OS_TOKEN
MIIDdAYJKoZIhvcNAQcCoIIDZTCCA2ECAQExDTALBglghkgBZQMEAgEwggHCBgkqhkiG9w0BBwGgggGzBIIBr3sidG9rZW4iOnsiZG9tYWluIjp7ImlkIjoiODIzMmVmZjgyODI2NDQyNzk5ZWEzNDc3NmM3OTg5OWUiLCJuYW1lIjoidGVsbmV0MSJ9LCJtZXRob2RzIjpbInBhc3N3b3JkIl0sInJvbGVzIjpbeyJpZCI6ImUxMzdlN2UwMmRmNDQ0ZTliMDNhNWQyYTAxMTM0NmVmIiwibmFtZSI6ImFkbWluIn1dLCJleHBpcmVzX2F0IjoiMjAxNi0xMi0wNFQwMzozNzowNS45MjUyNTJaIiwidXNlciI6eyJkb21haW4iOnsiaWQiOiI4MjMyZWZmODI4MjY0NDI3OTllYTM0Nzc2Yzc5ODk5ZSIsIm5hbWUiOiJ0ZWxuZXQxIn0sImlkIjoiNTczZmYwYTJlMWFmNDFiYjhmNDA1YTUzNmEwZGQ0Y2MiLCJuYW1lIjoidGVsbmV0QWRtaW4ifSwiYXVkaXRfaWRzIjpbImQ5enYzX0IyU0RXc3lhS2FGU1BNWmciXSwiaXNzdWVkX2F0IjoiMjAxNi0xMi0wNFQwMjozNzowNS45MjUyNzFaIn19MYIBhTCCAYECAQEwXDBXMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVW5zZXQxDjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tAgEBMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA+qK4MgVVX5TPNGtoIB12U7n-vnepjMddJCubu2qpLY2It2jHNC9-En-FHTz-hZNEAsi5G6abLXu5mvC-TIJrpMIqOc25XLgXZbFIRUOoyf1uDEkGk1nKh+FgBFMp0RSTmGAe2cixtBsTyKRIZVCDQma+Ba0IUzi7lnQxI+xZooh-sFnZI04acEq-optbTK75yCwu8S13b0bYzA3SG76H8V7TKSM8tJGQ7MQl-ArHnEBME9WAByjgveUEb9yOiW8FTTZJEapb1h9ayVHouN3180+S7j6m+dsrpbZj7FKoBzJqJbqyAH3SpgtAuPeL5lEj1WcE-JYQtQ+ssXi4+tw3L
```

## Check token
Token不携带catalog。
```
# curl -s -H "X-Subject-Token: $OS_TOKEN" -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/auth/tokens | python -m json.tool
{
    "token": {
        "audit_ids": [
            "d9zv3_B2SDWsyaKaFSPMZg"
        ],
        "domain": {
            "id": "8232eff82826442799ea34776c79899e",
            "name": "telnet1"
        },
        "expires_at": "2016-12-04T03:37:05.925252Z",
        "issued_at": "2016-12-04T02:37:05.925271Z",
        "methods": [
            "password"
        ],
        "roles": [
            {
                "id": "e137e7e02df444e9b03a5d2a011346ef",
                "name": "admin"
            }
        ],
        "user": {
            "domain": {
                "id": "8232eff82826442799ea34776c79899e",
                "name": "telnet1"
            },
            "id": "573ff0a2e1af41bb8f405a536a0dd4cc",
            "name": "telnetAdmin"
        }
    }
}
```
## Get catalog
```
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/auth/catalog | python -m json.tool
```

## List users:
```
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/users | python -m json.tool
{
    "error": {
        "code": 403,
        "message": "You are not authorized to perform the requested action: identity:list_users",
        "title": "Forbidden"
    }
}

租户管理员list用户必须带domain_id参数。
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/users?domain_id=8232eff82826442799ea34776c79899e | python -m json.tool
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://192.168.56.101:5000/v3/users?domain_id=8232eff82826442799ea34776c79899e"
    },
    "users": [
        {
            "description": "Telnet Admin User description",
            "domain_id": "8232eff82826442799ea34776c79899e",
            "email": "telnet1@huawei.com",
            "enabled": true,
            "id": "573ff0a2e1af41bb8f405a536a0dd4cc",
            "links": {
                "self": "http://192.168.56.101:5000/v3/users/573ff0a2e1af41bb8f405a536a0dd4cc"
            },
            "name": "telnetAdmin"
        }
    ]
}
```

## Create the telnet user with telnet domain 
```
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "user": {
        "name": "telnetUser1", 
        "password": "Letmein123", 
        "email": "telnetUser1@huawei.com",
        "description": "Telnet User description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/users | python -mjson.tool
{
    "error": {
        "code": 403,
        "message": "You are not authorized to perform the requested action: identity:create_user",
        "title": "Forbidden"
    }
}

租户创建用户必须带domain_id参数：
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "user": {
        "domain_id": "8232eff82826442799ea34776c79899e", 
        "name": "telnetUser1", 
        "password": "Letmein123", 
        "email": "telnetUser1@huawei.com",
        "description": "Telnet User description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/users | python -mjson.tool
{
    "user": {
        "description": "Telnet User description",
        "domain_id": "8232eff82826442799ea34776c79899e",
        "email": "telnetUser1@huawei.com",
        "enabled": true,
        "id": "d9ac23c38eb14599bdbf966f13e6683c",
        "links": {
            "self": "http://192.168.56.101:5000/v3/users/d9ac23c38eb14599bdbf966f13e6683c"
        },
        "name": "telnetUser1"
    }
}
```

