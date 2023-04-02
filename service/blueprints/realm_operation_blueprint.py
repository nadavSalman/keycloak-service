from flask import Blueprint, jsonify, request, abort
from keycloak import KeycloakAdmin
from service.model.realm import Realm, RealmSchema
from marshmallow import ValidationError
import os

keycloak_admin = KeycloakAdmin(server_url=f"https://{os.getenv('KEYCLOACK_SERVER_IP')}:8443/auth/",
                               username="admin",
                               password="Q1w2e3r4t5y6",
                               realm_name="master",
                               verify=False)


def create_realm(realm_name: str):
    realm = keycloak_admin.create_realm({'realm': realm_name},skip_exists=True)
    return f"Realm {realm_name} created successfully!"


def create_realm_operation_blueprint(blueprint_name: str, operation_type: str) -> Blueprint:
    blueprint = Blueprint(blueprint_name, __name__)

    @blueprint.route(f'/{operation_type}', methods=["POST"])
    def create_resource():
        print(request.json)
        realm_schema = RealmSchema(many=True)
        updated_realms = []
        try:
            realms = realm_schema.load(request.json)  
            for realm in realms:
                updated_realms.append(create_realm(realm.get_name()))
        except ValidationError as err:
            print(err.messages) 
            return err.messages, 400

        return f"{updated_realms} \n realms created  successfully!", 200

    return blueprint