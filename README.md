# keycloak-service

---




## Keycloak Automation Assignment 


### Technical Details
* You can choose any programming language of your choice for this assignment
* Same goes for any other tech you choose to leverage, the only thing you should stick to using is keycloak as the IDP
* The container image for keycloak that you should use is `jboss/keycloak:16.1.1`
* Your delivery should run locally without requiring access to external cloud assets


### Functional Requirements 

1. Data persistency - Make sure data is persistent, e.g if the keycloak container is paused, stopped or deleted, data will persist
2. Write an http service that can serve requests, with an endpoint that once invoked, create a realm in keycloak. Realm name should be passed to that endpoint as a required argument.
   - Realm names should be a valid subdomain (dns)
3. Should be able to create multiple realms (Create several realms)
4. We want to introduce and enforce a new password creation policy for all existing realms, how should we do it? you don’t have to
implement this step, but please provide your suggested design.


### DOD 
As a user I would like to run keycloak locally with ease, and be able to create new realms with ease, without having to log into the keycloak admin
panel.


---

The requested image to use for keycloak is based on linux/amd64 (I will fail to run on Apple Silicon Macs). For that reason, I created a dev infra with Terraform that creates an ubuntu 22_04-lts on Azure.

### Prerequisites    
* You must have Docker installed on your system for the delivery to run locally.
   I have  provisioned my infrastructure to include Docker using Ansible check it out under provision-infra:
   ```
      .
      ├── provision-infra
      │   ├── Install-Docker
      │   ├── Install-Docker-Compose
      │   ├── inventory.yaml
      │   ├── provision-infra.sh
      │   └── provision-infrastructure-playbook.yaml
   ```
* Make sure your system have the container image : `jboss/keycloak:16.1.1` by pulling the image or it will be pulled when running the  command
   ```
   docker pull jboss/keycloak:16.1.1
   ```



### Runtime configuration


The version `jboss/keycloak:16.1.1`  must run with HTTPS over port 8443, otherwise the `Administration Console` wount be accessible. 
Acording to the image doc at Docker Hub [jboss/keycloak ](https://hub.docker.com/r/jboss/keycloak)  can run securly by mount `tls.crt` `tls.key` 
file to the path : `/etc/x509/https` inside the container.
I created a self-singed certificets placed unde certificates dir.

If you would like to generate the pair yourself run :
``` 
openssl req -newkey rsa:2048 -nodes \
  -keyout tls.key -x509 -days 3650 -out tls.crt
```


Data persistency - By default, Keycloak is using its embedded H2 database. The default database is located in /opt/jboss/keycloak/standalone/data/ the name is keycloak.mv.db
At runtime a volume map correspondly : ```./h2-data/:/opt/jboss/keycloak/standalone/data/```







An http service develope using Python Flask.
*  create a realm in keycloak


### Add new Realms


Pay load structure :
```
[    
    {"name": "QA"},
    {"name": "Staging"}
]
```

```
$ curl --location 'http://localhost:5000/api/create' --header 'Content-Type: application/json' --data '[    
    {"name": "QA"},
    {"name": "Staging"}
]'
['Realm QA created successfully!', 'Realm Staging created successfully!'] 
$
```

Sen a request with realm nat a valin subdomain for the realm name :

```
$ curl --location 'http://localhost:5000/api/create' --header 'Content-Type: application/json' --data '[    
    {"name": "@#$google"}
]'
{
  "0": {
    "name": [
      "A subdomain should contain only letters, numbers, and dashes."
    ]
  }
}
$
```








