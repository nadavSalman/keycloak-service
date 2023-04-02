from marshmallow import Schema, fields, post_load ,validates, ValidationError
import re

class Realm:
    def __init__(self, name):
        self.name = name

    def get_name(self):
        return self.name

    def __str__(self) -> str:
        return f'Realn Name : {self.name}'

class RealmSchema(Schema):
    name = fields.Str(required=True)
    
    @validates("name")
    def validate_subdomain(self,value):
        # Check if subdomain is non-empty and has no more than 63 characters
        if not value or len(value) > 63:
            raise ValidationError("Realm name length must be between 0-63.")
        # Check if subdomain consists of only letters, numbers, and hyphens
        if not re.match(r'^[a-zA-Z0-9-]+$', value):
            raise ValidationError("Realm name should contain only letters, numbers, and dashes")
        # Check if subdomain starts and ends with a letter or number
        if not re.match(r'^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$', value):
            raise ValidationError("Realm name should start and end with a letter or number.")

    @post_load
    def make_realm(self, data, **kwargs):
        return Realm(**data)