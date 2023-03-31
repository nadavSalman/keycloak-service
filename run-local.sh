#!/bin/bash


#  Apple Silicon Mac Users 
# For some quick background, new Apple Silicon Macs run on different architecture, 
# whereas Macs have been running Intel chips for quite some time. 
# Rosetta 2 translates Intel x86 code to ARM so that it can run on the new Apple Silicon hardware. 
# Install Rosetta 2 via CLI 
#softwareupdate --install-rosetta




# By default there is no admin user created so you won't be able to login to the admin console. 
# To create an admin account you need to use environment variables to pass in an initial username and password.
CONTAINER_ID=$(docker run   --platform=linux/amd64 --name keycloak -d  -p 8080:8080 -e ROOT_LOGLEVEL=DEBUG -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=Q1w2e3r4t5y6 jboss/keycloak:16.1.1 )
echo "CONTAINER_ID -> $CONTAINER_ID"





docker run   \
    --name keycloak -d  \
    -p 8443:8443 \
    -e ROOT_LOGLEVEL=DEBUG \
    -e KEYCLOAK_USER=admin \
    -e KEYCLOAK_PASSWORD=Q1w2e3r4t5y6 \
    -v /home/devops/cets:/etc/x509/https \
    jboss/keycloak:16.1.1


docker exec -it keycloak bash
#CONTAINER_ID=$(docker run   --platform=linux/amd64 --name keycloak -d  -p 8080:8080 -e KEYCLOAK_USER=nadav -e  KEYCLOAK_PASSWORD=123456 -e ROOT_LOGLEVEL=DEBUG jboss/keycloak:16.1.1 )


# Logs

# sh-4.4$ cat /opt/jboss/keycloak/standalone/configuration/keycloak-add-user.json
# [ {
#   "realm" : "master",
#   "users" : [ {
#     "username" : "nadav",
#     "enabled" : true,
#     "credentials" : [ {
#       "type" : "password",
#       "secretData" : "{\"value\":\"E1ZxzMrkxzcKAHAjYKOUsfnBQll+iDrls+ASZtOOaaJL1dQ/YYALGe/+sgn7lJ5wftmFYBEiXo7gPJIzUHzCHA==\",\"salt\":\"qMveX1pzysjolhtvEmYeAw==\",\"additionalParameters\":{}}",
#       "credentialData" : "{\"hashIterations\":100000,\"algorithm\":\"pbkdf2-sha256\",\"additionalParameters\":{}}"
#     } ],
#     "realmRoles" : [ "admin" ]
#   } ]
# } ]sh-4.4$ 



echo "CONTAINER_ID -> $CONTAINER_ID"

# You can also create an account on an already running container by running:
USERNAME='nadav'
PASSWORD='salman'
docker exec $CONTAINER_ID /opt/jboss/keycloak/bin/add-user-keycloak.sh -u $USERNAME -p $PASSWORD

docker logs $CONTAINER_ID -f 
# Added 'nadav' to '/opt/jboss/keycloak/standalone/configuration/keycloak-add-user.json', restart server to load user
# Then restarting the container:
# docker restart  keycloak 


# ERROR [org.jboss.modcluster] (ServerService Thread Pool -- 56) MODCLUSTER000034: Failed to start advertise listener: java.net.SocketException: Protocol not available (Error setting socket option)