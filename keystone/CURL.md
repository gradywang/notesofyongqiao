# Keystone V3 API
export KEYSTONE_SERVER=192.168.56.103

## Get get the domain-scoped token of system administrator
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
}' | grep ^X-Subject-Token: | awk '{print $2}' )

# echo $OS_TOKEN
MIIFfwYJKoZIhvcNAQcCoIIFcDCCBWwCAQExDTALBglghkgBZQMEAgEwggPNBgkqhkiG9w0BBwGgggO+BIIDunsidG9rZW4iOnsiZG9tYWluIjp7ImlkIjoiZDE1MzkwYTBmZWUzNDE0YzhkNzhkOGE3OGY2NTQ0N2MiLCJuYW1lIjoiZGVmYXVsdCJ9LCJtZXRob2RzIjpbInBhc3N3b3JkIl0sInJvbGVzIjpbeyJpZCI6ImRkZjdlOWQwOTc3ZDQ3NTI4OWNkNWQzMGUxNDljOTAwIiwibmFtZSI6ImFkbWluIn1dLCJleHBpcmVzX2F0IjoiMjAxNi0xMi0wM1QwOToyMTowNy43NzQ4NDBaIiwiY2F0YWxvZyI6W3siZW5kcG9pbnRzIjpbeyJyZWdpb25faWQiOiJSZWdpb25PbmUiLCJ1cmwiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAvdjMiLCJyZWdpb24iOiJSZWdpb25PbmUiLCJpbnRlcmZhY2UiOiJpbnRlcm5hbCIsImlkIjoiMWNkNTJiNWU4ZGNhNDBmM2FhMzQwMTlkM2UzZGE2N2QifSx7InJlZ2lvbl9pZCI6IlJlZ2lvbk9uZSIsInVybCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzUzNTcvdjMiLCJyZWdpb24iOiJSZWdpb25PbmUiLCJpbnRlcmZhY2UiOiJhZG1pbiIsImlkIjoiNzAyMWFhZWQ0OTIwNGMxN2E4ZjY4ZDlhYmY0Y2Q2NzIifSx7InJlZ2lvbl9pZCI6IlJlZ2lvbk9uZSIsInVybCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAwMC92MyIsInJlZ2lvbiI6IlJlZ2lvbk9uZSIsImludGVyZmFjZSI6InB1YmxpYyIsImlkIjoiOWZhZWE0YjI3YTE0NDM0ZDk5ZTNhMGUyYmYxMWY4ZmIifV0sInR5cGUiOiJpZGVudGl0eSIsImlkIjoiMmY1N2Y2NTcwNWU1NGRkNWFhYzEzNzAyYWI5ZGFmZGUiLCJuYW1lIjoia2V5c3RvbmUifV0sInVzZXIiOnsiZG9tYWluIjp7ImlkIjoiZDE1MzkwYTBmZWUzNDE0YzhkNzhkOGE3OGY2NTQ0N2MiLCJuYW1lIjoiZGVmYXVsdCJ9LCJpZCI6ImI4MjIwZGI0YmU5YzRkMzk5N2E4OWQxOWU1ODZlZGVlIiwibmFtZSI6ImFkbWluIn0sImF1ZGl0X2lkcyI6WyJBOTRJbzN1TFQtU2VlNGdSUzhNVzBBIl0sImlzc3VlZF9hdCI6IjIwMTYtMTItMDNUMDg6MjE6MDcuNzc0ODYxWiJ9fTGCAYUwggGBAgEBMFwwVzELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVVuc2V0MQ4wDAYDVQQHDAVVbnNldDEOMAwGA1UECgwFVW5zZXQxGDAWBgNVBAMMD3d3dy5leGFtcGxlLmNvbQIBATALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAm-gL7smtKSApr-ufQ8TW7b3pq7pZyqejPUl291uXwrM2f2eFB2uIMd+jr0a2haz3wNCJcVQ7tcD9OzKm2ipsrO1dEWmNkkqUJzqMAFeu0nUBpJUy86vaUYPWgsKd2TyTEhvFg7M8gfWvH2j8T43+OB27AjN3s3bgYGAjzb6jDYUIw0ZiZ9CrBGQf9WVRnCL4OfTvtZFPQiHZ8vRBbSvs4tjEqINuaWdwLzd5qe12t-badLwBuCNq4se3EObrgy1teei2f5M6ywEgQhF59B9Ad8uWqHQfz1Jf4U6Hf3a7Rs4IoUDLO9aVx1AJJn3sqD-b9CzhCaKMI4rAv6kb0oF4KA==
```

## List the users 
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

## Create the telnet domain
```
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "domain": {
        "name": "telnet1", 
        "description": "Domain description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/domains | python -mjson.tool

c419495ae28d43fc9085311b3ca4829e
```

## Create the admin user for telnet 
```
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "user": {
        "domain_id": "c419495ae28d43fc9085311b3ca4829e", 
        "name": "user1", 
        "password": "Letmein123", 
        "description": "User description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/users | python -mjson.tool

3898cea9c35b4d8b9986a09abf9feacc
```

## Create role for telnet admin
```
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "role": {
        "domain_id": "c419495ae28d43fc9085311b3ca4829e", 
        "name": "telnetadmin", 
        "description": "Role description"
    }
}' http://${KEYSTONE_SERVER}:5000/v3/roles | python -mjson.tool

83360ec3e5884ce0916979517f80fb71
```

## Assign telnet admin user to telnet domain with the telnet admin role
```
#　curl -s \
　　-X PUT \
   -H "X-Auth-Token: $OS_TOKEN" \
   http://${KEYSTONE_SERVER}:5000/v3/domains/c419495ae28d43fc9085311b3ca4829e/users/3898cea9c35b4d8b9986a09abf9feacc/roles/83360ec3e5884ce0916979517f80fb71
```

## Get get the domain-scoped token of telnet administrator
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
                        "name": "telnet1"
                    },
                    "name": "user1",
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
}' | grep ^X-Subject-Token: | awk '{print $2}' )

# echo $OS_TOKEN
MIIFfwYJKoZIhvcNAQcCoIIFcDCCBWwCAQExDTALBglghkgBZQMEAgEwggPNBgkqhkiG9w0BBwGgggO+BIIDunsidG9rZW4iOnsiZG9tYWluIjp7ImlkIjoiZDE1MzkwYTBmZWUzNDE0YzhkNzhkOGE3OGY2NTQ0N2MiLCJuYW1lIjoiZGVmYXVsdCJ9LCJtZXRob2RzIjpbInBhc3N3b3JkIl0sInJvbGVzIjpbeyJpZCI6ImRkZjdlOWQwOTc3ZDQ3NTI4OWNkNWQzMGUxNDljOTAwIiwibmFtZSI6ImFkbWluIn1dLCJleHBpcmVzX2F0IjoiMjAxNi0xMi0wM1QwOToyMTowNy43NzQ4NDBaIiwiY2F0YWxvZyI6W3siZW5kcG9pbnRzIjpbeyJyZWdpb25faWQiOiJSZWdpb25PbmUiLCJ1cmwiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAvdjMiLCJyZWdpb24iOiJSZWdpb25PbmUiLCJpbnRlcmZhY2UiOiJpbnRlcm5hbCIsImlkIjoiMWNkNTJiNWU4ZGNhNDBmM2FhMzQwMTlkM2UzZGE2N2QifSx7InJlZ2lvbl9pZCI6IlJlZ2lvbk9uZSIsInVybCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzUzNTcvdjMiLCJyZWdpb24iOiJSZWdpb25PbmUiLCJpbnRlcmZhY2UiOiJhZG1pbiIsImlkIjoiNzAyMWFhZWQ0OTIwNGMxN2E4ZjY4ZDlhYmY0Y2Q2NzIifSx7InJlZ2lvbl9pZCI6IlJlZ2lvbk9uZSIsInVybCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAwMC92MyIsInJlZ2lvbiI6IlJlZ2lvbk9uZSIsImludGVyZmFjZSI6InB1YmxpYyIsImlkIjoiOWZhZWE0YjI3YTE0NDM0ZDk5ZTNhMGUyYmYxMWY4ZmIifV0sInR5cGUiOiJpZGVudGl0eSIsImlkIjoiMmY1N2Y2NTcwNWU1NGRkNWFhYzEzNzAyYWI5ZGFmZGUiLCJuYW1lIjoia2V5c3RvbmUifV0sInVzZXIiOnsiZG9tYWluIjp7ImlkIjoiZDE1MzkwYTBmZWUzNDE0YzhkNzhkOGE3OGY2NTQ0N2MiLCJuYW1lIjoiZGVmYXVsdCJ9LCJpZCI6ImI4MjIwZGI0YmU5YzRkMzk5N2E4OWQxOWU1ODZlZGVlIiwibmFtZSI6ImFkbWluIn0sImF1ZGl0X2lkcyI6WyJBOTRJbzN1TFQtU2VlNGdSUzhNVzBBIl0sImlzc3VlZF9hdCI6IjIwMTYtMTItMDNUMDg6MjE6MDcuNzc0ODYxWiJ9fTGCAYUwggGBAgEBMFwwVzELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVVuc2V0MQ4wDAYDVQQHDAVVbnNldDEOMAwGA1UECgwFVW5zZXQxGDAWBgNVBAMMD3d3dy5leGFtcGxlLmNvbQIBATALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAm-gL7smtKSApr-ufQ8TW7b3pq7pZyqejPUl291uXwrM2f2eFB2uIMd+jr0a2haz3wNCJcVQ7tcD9OzKm2ipsrO1dEWmNkkqUJzqMAFeu0nUBpJUy86vaUYPWgsKd2TyTEhvFg7M8gfWvH2j8T43+OB27AjN3s3bgYGAjzb6jDYUIw0ZiZ9CrBGQf9WVRnCL4OfTvtZFPQiHZ8vRBbSvs4tjEqINuaWdwLzd5qe12t-badLwBuCNq4se3EObrgy1teei2f5M6ywEgQhF59B9Ad8uWqHQfz1Jf4U6Hf3a7Rs4IoUDLO9aVx1AJJn3sqD-b9CzhCaKMI4rAv6kb0oF4KA==
```