# Keystone V3 API
export KEYSTONE_SERVER=192.168.56.103

## Get get the domain-scoped token of system administrator
```
# curl -i \
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
                    "name": "admin", 
                    "domain": {
                        "name": "default"
                    }, 
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
}' http://${KEYSTONE_SERVER}:5000/v3/auth/tokens ; echo
```