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

---

The requested image to use for keycloak is based on linux/amd64 (I will fail to run on Apple Silicon Macs). For that reason, I created a dev infra with Terraform that creates an ubuntu 22_04-lts on Azur

### Prerequisites    
* You must have Docker installed on your system.
   I have  provisioned my infrastructure to include docker using Ansible check it out under provision-infra:
   ```
      .
      ├── README.md
      ├── dev-infra
      ├── provision-infra
      └── run-local.sh
   ```
* Make sure your system have the container image : `jboss/keycloak:16.1.1`
   ```
   docker pull jboss/keycloak:16.1.1
   ```


The version `jboss/keycloak:16.1.1`  must run with HTTPS over port 8443, otherwise the `Administration Console` wount be accessible. 
Acording to the imagfe doc at [Docker Hub / keycloack ](https://hub.docker.com/r/jboss/keycloak)  can run securly by mount `tls.crt` `tls.key` 
file to the path : `/etc/x509/https` inside the container.
I created a self-singed certificets placed unde certificates dir.
If you would lke ti generate apair yourlef run :
``` 
openssl req -newkey rsa:2048 -nodes \
  -keyout tls.key -x509 -days 3650 -out tls.crt
```
```
docker run   \
    --name keycloak -d  \
    -p 8443:8443 \
    -e ROOT_LOGLEVEL=DEBUG \
    -e KEYCLOAK_USER=admin \
    -e KEYCLOAK_PASSWORD=Q1w2e3r4t5y6 \
    -v /home/devops/cets:/etc/x509/https \
    jboss/keycloak:16.1.1

```











