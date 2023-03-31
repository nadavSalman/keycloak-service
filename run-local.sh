#!/bin/bash

# Run KeyKloack container.
# By default there is no admin user created so you won't be able to login to the admin console. 
# To create an admin account you need to use environment variables to pass in an initial username and password.
function run() {
    docker run   \
        --name keycloak -d  \
        -p 8443:8443 \
        -e ROOT_LOGLEVEL=DEBUG \
        -e KEYCLOAK_USER=admin \
        -e KEYCLOAK_PASSWORD=Q1w2e3r4t5y6 \
        -v ./cets:/etc/x509/https \
        -v ./h2-data/:/opt/jboss/keycloak/standalone/data/ \
        jboss/keycloak:16.1.1
}

function containers_clean_up() {
    docker rm $(docker stop $(docker ps -aq))
}



# Check the parameter value and execute the corresponding function
case "$1" in
    "run")
        run

        # white for the keykloac service to be alive.
        while true; do
        response=$(curl  --head -fsS --insecure  https://localhost:8443/)
        status=$(echo "$response" | grep -i "HTTP/1.1" | awk '{print $2}')
        
        if [[ "$status" == "200" ]]; then
            echo "Server is ready"
            break
        else
            echo "Server is not ready (HTTP status code $status)"
            sleep 5
        fi
        done


        ;;



    "clean")
        containers_clean_up
        ;;

    *)
        echo "Invalid parameter, enter run or clean "
        ;;
esac