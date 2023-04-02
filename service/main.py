from flask import Flask, jsonify, request ,url_for 
import requests
from service.blueprints.realm_operation_blueprint import create_realm_operation_blueprint




# Keykloack rest api request implementation.
def get_keykloack_rest_api_admin_access_token():
    url = "https://172.174.72.74:8443/auth/realms/master/protocol/openid-connect/token"

    payload='grant_type=password&client_id=admin-cli&username=admin&password=Q1w2e3r4t5y6'
    headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
    }

    response = requests.request("POST", url, headers=headers, data=payload,verify=False)

    return response.json()['access_token']




app = Flask(__name__)

# Endpoints to create :
'''
(1) POST /create relam

 Realm name should be passed to that endpoint as a required argument.
 Should be able to create multiple realms (Create several realms)
 Realm names should be a valid subdomain (dns)

'''
app.register_blueprint(
    create_realm_operation_blueprint(
        "realm",
        "create"
    ),
    url_prefix='/api'
)



@app.route('/')
def get_api_root():
    return jsonify("KeyKloack client"), 200


if __name__=="__main__":    
    app.run("0.0.0.0", port=5000, debug=True)