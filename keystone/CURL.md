Cloud Admin and Domain Admin
https://www.rdoproject.org/documentation/domains/

# Keystone V3 API
export KEYSTONE_SERVER=192.168.56.103

## Get get the domain-scoped token of cloud administrator
```
# OS_TOKEN=$(\
curl http://${KEYSTONE_SERVER}:5000/v3/auth/tokens?nocatalog \
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
MIIDbgYJKoZIhvcNAQcCoIIDXzCCA1sCAQExDTALBglghkgBZQMEAgEwggG8BgkqhkiG9w0BBwGgggGtBIIBqXsidG9rZW4iOnsiZG9tYWluIjp7ImlkIjoiNjMzODY1NzU3YmI3NDM5YmJiMDQxOGNhODRlNTIzNmQiLCJuYW1lIjoiZGVmYXVsdCJ9LCJtZXRob2RzIjpbInBhc3N3b3JkIl0sInJvbGVzIjpbeyJpZCI6ImVhMWU0ZWQ2OThkZjQwOWE4NGE3YTZlNTYyMDA5MzI0IiwibmFtZSI6ImFkbWluIn1dLCJleHBpcmVzX2F0IjoiMjAxNi0xMi0wNFQwNTo1MjozNC40NTAwMTRaIiwidXNlciI6eyJkb21haW4iOnsiaWQiOiI2MzM4NjU3NTdiYjc0MzliYmIwNDE4Y2E4NGU1MjM2ZCIsIm5hbWUiOiJkZWZhdWx0In0sImlkIjoiZWY5YTZkOWZkMDRmNGQ5Nzk1OWJhNGY3OTczMDk3NTMiLCJuYW1lIjoiYWRtaW4ifSwiYXVkaXRfaWRzIjpbIktUa29tYXFWVHJhUDRMWm40bVoxZ0EiXSwiaXNzdWVkX2F0IjoiMjAxNi0xMi0wNFQwNDo1MjozNC40NTAwMzFaIn19MYIBhTCCAYECAQEwXDBXMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVW5zZXQxDjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tAgEBMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAomy7+D045+7uEbOkfntVqhAfxvw88P7i8oXS+pFEdSm4OFvy9fguYWgOC1iAnomTxdypNxPWy7FdGb8DLdH7fJ18QavFSYPw2Des4H7H4vsZAGN6vaikil4nI7+Sg003JQWul1A68QPYAc9O2V0EgKyBdcxJtiDO7yRU4jLK6t+MMSPLkMh4nJeByhWN+yehnaNQlCuTP9QS7fNhN01gMMEO3YqIqVuWLsZDEW00IhiSg6sD9Jy2Gg+k6jLUQ6t0Ke3DUVy9x0doVC2L7MDLgxAto7PYk2ojO1CU6+f2y5hNc6bGMmSU2YNfCd3kKTqs5WBHQ5p4f0L7dTEg-jWgf
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
            "domain_id": "633865757bb7439bbb0418ca84e5236d",
            "enabled": true,
            "id": "ef9a6d9fd04f4d97959ba4f797309753",
            "links": {
                "self": "http://192.168.56.101:5000/v3/users/ef9a6d9fd04f4d97959ba4f797309753"
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
            "id": "ea1e4ed698df409a84a7a6e562009324",
            "links": {
                "self": "http://192.168.56.101:5000/v3/roles/ea1e4ed698df409a84a7a6e562009324"
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
            "id": "633865757bb7439bbb0418ca84e5236d",
            "links": {
                "self": "http://192.168.56.101:5000/v3/domains/633865757bb7439bbb0418ca84e5236d"
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

## List projects
云管理员可以查询到所有的项目（包括管理域和租户域的）
```
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/projects | python -m json.tool
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://192.168.56.101:5000/v3/projects"
    },
    "projects": [
        {
            "description": "Telnet project description",
            "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0",
            "enabled": true,
            "id": "f1bb57baaac34121b8fd7320d5ba91f2",
            "is_domain": false,
            "links": {
                "self": "http://192.168.56.101:5000/v3/projects/f1bb57baaac34121b8fd7320d5ba91f2"
            },
            "name": "telnetProject",
            "parent_id": "f5d1fe9c284d441cb89a1c553fc242a0"
        }
    ]
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
        "id": "f5d1fe9c284d441cb89a1c553fc242a0",
        "links": {
            "self": "http://192.168.56.101:5000/v3/domains/f5d1fe9c284d441cb89a1c553fc242a0"
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
        "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0", 
        "name": "telnetAdmin", 
        "password": "Letmein123", 
        "email": "telnetAdmin@huawei.com",
        "description": "Telnet Admin User description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/users | python -mjson.tool
{
    "user": {
        "description": "Telnet Admin User description",
        "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0",
        "email": "telnetAdmin@huawei.com",
        "enabled": true,
        "id": "6327f1dd79144f5fbb0007c4acd50842",
        "links": {
            "self": "http://192.168.56.101:5000/v3/users/6327f1dd79144f5fbb0007c4acd50842"
        },
        "name": "telnetAdmin"
    }
}
```

## Assign telnet admin user to telnet domain with admin role
```
# curl -i -X "PUT" -H "X-Auth-Token: $OS_TOKEN" http://${KEYSTONE_SERVER}:5000/v3/domains/f5d1fe9c284d441cb89a1c553fc242a0/users/6327f1dd79144f5fbb0007c4acd50842/roles/ea1e4ed698df409a84a7a6e562009324
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
MIIDdAYJKoZIhvcNAQcCoIIDZTCCA2ECAQExDTALBglghkgBZQMEAgEwggHCBgkqhkiG9w0BBwGgggGzBIIBr3sidG9rZW4iOnsiZG9tYWluIjp7ImlkIjoiZjVkMWZlOWMyODRkNDQxY2I4OWExYzU1M2ZjMjQyYTAiLCJuYW1lIjoidGVsbmV0MSJ9LCJtZXRob2RzIjpbInBhc3N3b3JkIl0sInJvbGVzIjpbeyJpZCI6ImVhMWU0ZWQ2OThkZjQwOWE4NGE3YTZlNTYyMDA5MzI0IiwibmFtZSI6ImFkbWluIn1dLCJleHBpcmVzX2F0IjoiMjAxNi0xMi0wNFQwNTo1NDo1OS41NDc5NjNaIiwidXNlciI6eyJkb21haW4iOnsiaWQiOiJmNWQxZmU5YzI4NGQ0NDFjYjg5YTFjNTUzZmMyNDJhMCIsIm5hbWUiOiJ0ZWxuZXQxIn0sImlkIjoiNjMyN2YxZGQ3OTE0NGY1ZmJiMDAwN2M0YWNkNTA4NDIiLCJuYW1lIjoidGVsbmV0QWRtaW4ifSwiYXVkaXRfaWRzIjpbIjFLN1RZUGkwUnlLN09xbUNkcVYwbFEiXSwiaXNzdWVkX2F0IjoiMjAxNi0xMi0wNFQwNDo1NDo1OS41NDc5ODJaIn19MYIBhTCCAYECAQEwXDBXMQswCQYDVQQGEwJVUzEOMAwGA1UECAwFVW5zZXQxDjAMBgNVBAcMBVVuc2V0MQ4wDAYDVQQKDAVVbnNldDEYMBYGA1UEAwwPd3d3LmV4YW1wbGUuY29tAgEBMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAG+BC4-iW4djamKeqn4BXMShaLLXWhxDieJKwdipZr3IdJ0P3TkmQ4zfknTZsu7uLE9JP1YHO+GCwA9F3Q1xoQX1vimc35aEMaVqNikM4c2xqgtbQNYoJCWtUz+KTyNjDpxsUs9nbeAVWHOzzt8UdFUxx0k00b3luzmDuxYBt2owo44pJLxtXk0x9q+TBhAuLOGM7be1JXRC2l874l3rCRwLRZskbO2fm5om1ipCMXtil8h7-uyp27eE9E7cyRsncWtvggrEVI+5I1Gpyb8pRt47EaPTZaQbJZBo3rDI5NzmgivsSnPh+q4kJp4ifZvBG43SgkkrQx3lcVsbYL0g4I
```

## Check token
Token不携带catalog。
```
# curl -s -H "X-Subject-Token: $OS_TOKEN" -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/auth/tokens | python -m json.tool
{
    "token": {
        "audit_ids": [
            "1K7TYPi0RyK7OqmCdqV0lQ"
        ],
        "domain": {
            "id": "f5d1fe9c284d441cb89a1c553fc242a0",
            "name": "telnet1"
        },
        "expires_at": "2016-12-04T05:54:59.547963Z",
        "issued_at": "2016-12-04T04:54:59.547982Z",
        "methods": [
            "password"
        ],
        "roles": [
            {
                "id": "ea1e4ed698df409a84a7a6e562009324",
                "name": "admin"
            }
        ],
        "user": {
            "domain": {
                "id": "f5d1fe9c284d441cb89a1c553fc242a0",
                "name": "telnet1"
            },
            "id": "6327f1dd79144f5fbb0007c4acd50842",
            "name": "telnetAdmin"
        }
    }
}
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
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/users?domain_id=f5d1fe9c284d441cb89a1c553fc242a0 | python -m json.tool
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://192.168.56.101:5000/v3/users?domain_id=f5d1fe9c284d441cb89a1c553fc242a0"
    },
    "users": [
        {
            "description": "Telnet Admin User description",
            "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0",
            "email": "telnetAdmin@huawei.com",
            "enabled": true,
            "id": "6327f1dd79144f5fbb0007c4acd50842",
            "links": {
                "self": "http://192.168.56.101:5000/v3/users/6327f1dd79144f5fbb0007c4acd50842"
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

租户管理员创建用户必须带domain_id参数：
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "user": {
        "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0", 
        "name": "telnetUser1", 
        "password": "Letmein123", 
        "email": "telnetUser1@huawei.com",
        "description": "Telnet User description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/users | python -mjson.tool
{
    "user": {
        "description": "Telnet User description",
        "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0",
        "email": "telnetUser1@huawei.com",
        "enabled": true,
        "id": "af355e22de7b46fca2be15052f093f3e",
        "links": {
            "self": "http://192.168.56.101:5000/v3/users/af355e22de7b46fca2be15052f093f3e"
        },
        "name": "telnetUser1"
    }
}
```

## List projects with the telent admin
```
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/projects | python -m json.tool
{
    "error": {
        "code": 403,
        "message": "You are not authorized to perform the requested action: identity:list_projects",
        "title": "Forbidden"
    }
}

租户管理员List项目，必须指定domain_id
# curl -s -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/projects?domain_id=f5d1fe9c284d441cb89a1c553fc242a0 | python -m json.tool
{
    "links": {
        "next": null,
        "previous": null,
        "self": "http://192.168.56.101:5000/v3/projects?domain_id=f5d1fe9c284d441cb89a1c553fc242a0"
    },
    "projects": []
}
```

## Create the telnet project
```
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "project": {
        "name": "telnetProject", 
        "description": "Telnet project description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/projects | python -mjson.tool
{
    "error": {
        "code": 403,
        "message": "You are not authorized to perform the requested action: identity:create_project",
        "title": "Forbidden"
    }
}

租户管理员创建project必须带domain_id参数：

# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "project": {
        "name": "telnetProject", 
        "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0", 
        "description": "Telnet project description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/projects | python -mjson.tool
{
    "project": {
        "description": "Telnet project description",
        "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0",
        "enabled": true,
        "id": "f1bb57baaac34121b8fd7320d5ba91f2",
        "is_domain": false,
        "links": {
            "self": "http://192.168.56.101:5000/v3/projects/f1bb57baaac34121b8fd7320d5ba91f2"
        },
        "name": "telnetProject",
        "parent_id": "f5d1fe9c284d441cb89a1c553fc242a0"
    }
}
```

## List roles with telnet admin
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
            "id": "ea1e4ed698df409a84a7a6e562009324",
            "links": {
                "self": "http://192.168.56.101:5000/v3/roles/ea1e4ed698df409a84a7a6e562009324"
            },
            "name": "admin"
        }
    ]
}
```

## Create role for telnet user
```
#　curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "role": {
        "name": "normalUser", 
        "description": "normalUser role description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/roles | python -mjson.tool
{
    "error": {
        "code": 403,
        "message": "You are not authorized to perform the requested action: identity:create_role",
        "title": "Forbidden"
    }
}

租户管理员创建role必须带domain_id参数：

#　curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "role": {
        "name": "normalUser", 
        "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0", 
        "description": "normalUser role description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/roles | python -mjson.tool
{
    "role": {
        "description": "normalUser role description",
        "domain_id": "f5d1fe9c284d441cb89a1c553fc242a0",
        "id": "ef7f940f367b4e538340da08295bea29",
        "links": {
            "self": "http://192.168.56.101:5000/v3/roles/ef7f940f367b4e538340da08295bea29"
        },
        "name": "normalUser"
    }
}
```
