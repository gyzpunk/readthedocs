import os

SLUMBER_USERNAME = 'docbuilder'
SLUMBER_PASSWORD = os.getenv('RTD_SLUMBER_PASSWORD', 'docbuilder')
PRODUCTION_DOMAIN = os.getenv('RTD_PRODUCTION_DOMAIN', 'localhost:8000')
SECRET_KEY = 'changemeplease'
