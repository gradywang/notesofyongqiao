# Cinder V2 API
```
# export CINDER_SERVER=192.168.56.110
# export KEYSTONE_SERVER=192.168.56.110
```

## Get the token
```
OS_TOKEN=$(\
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
                    "name": "cinder",
                    "password": "Letmein123"
                }
            }
        },
        "scope": {
            "project": {
                "name": "service",
                "domain": { "name": "default" }
            }
        }
    }
}' | grep ^X-Subject-Token: | awk '{print $2}' ) ; echo $OS_TOKEN
MIIDtAYJKoZIhvcNAQcCoIIDpTCCA6ECAQExDTALBglghkgBZQMEAgEwggICBgkqhkiG9w0BBwGgggHzBIIB73sidG9rZW4iOnsibWV0aG9kcyI6WyJwYXNzd29yZCJdLCJyb2xlcyI6W3siaWQiOiI1NjFhNjA5ZTc0OGI0NzJlOWMyNjc2M2E1M2Q2M2FkYyIsIm5hbWUiOiJhZG1pbiJ9XSwiZXhwaXJlc19hdCI6IjIwMTYtMTItMTdUMDg6MTE6MTQuODkxODA3WiIsInByb2plY3QiOnsiZG9tYWluIjp7ImlkIjoiYWQxNDQyMDUwZmMyNGJlYTlkMTZiY2FkOWZhMDViYzYiLCJuYW1lIjoiZGVmYXVsdCJ9LCJpZCI6IjY0OTI2MjFkMTcwMzQ4MGNiZjMxYTI4NDQyMGZkYTk4IiwibmFtZSI6InNlcnZpY2UifSwidXNlciI6eyJkb21haW4iOnsiaWQiOiJhZDE0NDIwNTBmYzI0YmVhOWQxNmJjYWQ5ZmEwNWJjNiIsIm5hbWUiOiJkZWZhdWx0In0sImlkIjoiODE2NzI1NmU0ODVlNDEyZmE3YmVkMTBkNzMwYjU5OWEiLCJuYW1lIjoiY2luZGVyIn0sImF1ZGl0X2lkcyI6WyJrS3FvMDhpaVNwV0FCampBNkxwaEtBIl0sImlzc3VlZF9hdCI6IjIwMTYtMTItMTdUMDc6MTE6MTQuODkxODI5WiJ9fTGCAYUwggGBAgEBMFwwVzELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVVuc2V0MQ4wDAYDVQQHDAVVbnNldDEOMAwGA1UECgwFVW5zZXQxGDAWBgNVBAMMD3d3dy5leGFtcGxlLmNvbQIBATALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAZGMNyY1igUuS1YOBe1WkjqeededhlzHMOoSaGWwAioD8p0LceWqy1gbZ5B3WPnXWfcI4FF4DKZeJ-9bxpsTI6msXXB3WPdMUT3LFAnxqt+2kMlssJDDEOj2Gvkxw69uL2LMnwdEt9dVEsH89rHdFJDgRH8Hj67PrQ-DrH+Qe21vFsQ2LUpT80Z9-8Cdaz6oQFc43qlDcG2975MRTYHkb02cpyMoVhOvZAPwQK5H7L+CsBTc8hAVapQWdWC67XTLyHWcvnXKrG1UJe+sTM9aUq0wguS8K2bsEbi1GPng7YSWI5Ttq5fXjJkeElJiG2iAtLPwIYZjPjfhV3bNpXR4OEA==
```

## Parse token
```
# curl -s -H "X-Subject-Token: $OS_TOKEN" -H "X-Auth-Token: $OS_TOKEN" -H "Content-Type: application/json"  http://${KEYSTONE_SERVER}:5000/v3/auth/tokens | python -m json.tool
{
    "token": {
        "audit_ids": [
            "GqPc1xc5RL6WUjdXZWWdig"
        ],
        "expires_at": "2016-12-17T09:24:36.283979Z",
        "issued_at": "2016-12-17T08:24:36.284002Z",
        "methods": [
            "password"
        ],
        "project": {
            "domain": {
                "id": "2a5ad7e0150e43ba84dfc66e68f758e0",
                "name": "default"
            },
            "id": "df6a46ab57d84788abffc9fbec043623",
            "name": "service"
        },
        "roles": [
            {
                "id": "32a534700012463ea29175086c3fbc55",
                "name": "admin"
            }
        ],
        "user": {
            "domain": {
                "id": "2a5ad7e0150e43ba84dfc66e68f758e0",
                "name": "default"
            },
            "id": "3bb9ac06b4a242688ab9635ef71fb188",
            "name": "cinder"
        }
    }
}
```


## Get the volumes of the projects in the corresponding token
```
# curl -H "X-Auth-Token:$OS_TOKEN" -s http://${CINDER_SERVER}:8776/v2/df6a46ab57d84788abffc9fbec043623/volumes/detail | python -mjson.tool
{
    "volumes": [
        {
            "attachments": [],
            "availability_zone": "nova",
            "bootable": "false",
            "consistencygroup_id": null,
            "created_at": "2016-12-18T11:44:21.000000",
            "description": "Description for the new volume.",
            "encrypted": false,
            "id": "c4027a62-c88c-4330-8800-f4836473ce0d",
            "links": [
                {
                    "href": "http://192.168.56.110:8776/v2/ed10dc336cce4d1c84316bdf685b0c7d/volumes/c4027a62-c88c-4330-8800-f4836473ce0d",
                    "rel": "self"
                },
                {
                    "href": "http://192.168.56.110:8776/ed10dc336cce4d1c84316bdf685b0c7d/volumes/c4027a62-c88c-4330-8800-f4836473ce0d",
                    "rel": "bookmark"
                }
            ],
            "metadata": {},
            "multiattach": false,
            "name": "newVolume",
            "os-vol-tenant-attr:tenant_id": "ed10dc336cce4d1c84316bdf685b0c7d",
            "replication_status": "disabled",
            "size": 1,
            "snapshot_id": null,
            "source_volid": null,
            "status": "available",
            "updated_at": "2016-12-18T11:44:22.000000",
            "user_id": "88dbd7e8bd3144629a88774f8e6680d8",
            "volume_type": null
        }
    ]
}
```

## Create a volumes for the project in the corresponding token
```
# curl -s \
  -H "X-Auth-Token: $OS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '
{
    "volume": {
        "size": "1", 
        "name": "newVolume",
        "description": "Description for the new volume."
    }
}' http://${CINDER_SERVER}:8776/v2/df6a46ab57d84788abffc9fbec043623/volumes | python -mjson.tool
{
    "volume": {
        "attachments": [],
        "availability_zone": "nova",
        "bootable": "false",
        "consistencygroup_id": null,
        "created_at": "2016-12-17T07:16:00.985715",
        "description": "Description for the new volume.",
        "encrypted": false,
        "id": "4312dc3a-56b0-418a-9e43-11544dc3fd16",
        "links": [
            {
                "href": "http://192.168.56.110:8776/v2/6492621d1703480cbf31a284420fda98/volumes/4312dc3a-56b0-418a-9e43-11544dc3fd16",
                "rel": "self"
            },
            {
                "href": "http://192.168.56.110:8776/6492621d1703480cbf31a284420fda98/volumes/4312dc3a-56b0-418a-9e43-11544dc3fd16",
                "rel": "bookmark"
            }
        ],
        "metadata": {},
        "multiattach": false,
        "name": "newVolume",
        "replication_status": "disabled",
        "size": 1,
        "snapshot_id": null,
        "source_volid": null,
        "status": "creating",
        "updated_at": null,
        "user_id": "8167256e485e412fa7bed10d730b599a",
        "volume_type": null
    }
}
```

