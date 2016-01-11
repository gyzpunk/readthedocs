import os

DATABASES = {
    'default': {
        'ENGINE': os.getenv('DJANGO_DB_ENGINE', 'django.db.backends.sqlite3'),
        'NAME': os.getenv('DJANGO_DB_NAME', os.path.join(SITE_ROOT, 'dev.db')),
        'USER': os.getenv('DJANGO_DB_USER', 'postgres'),  # Not used with sqlite3.
        'PASSWORD': os.getenv('DJANGO_DB_PASSWORD', ''),
        'HOST': os.getenv('DJANGO_DB_HOST', 'postgres'),
        'PORT': os.getenv('DJANGO_DB_PORT', ''),
    }
}

SLUMBER_USERNAME = 'docbuilder'
SLUMBER_PASSWORD = os.getenv('RTD_SLUMBER_PASSWORD', 'docbuilder')
PRODUCTION_DOMAIN = os.getenv('RTD_PRODUCTION_DOMAIN', 'localhost:8000')
SECRET_KEY = 'changemeplease'
