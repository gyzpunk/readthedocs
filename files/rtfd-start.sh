#!/bin/bash -x

cd $RTD_PATH

python manage.py syncdb --noinput
python manage.py migrate
echo "from django.contrib.auth.models import User; User.objects.create_superuser('docbuilder', 'docbuilder@localhost', '$RTD_SLUMBER_PASSWORD')" | ./manage.py shell
python manage.py makemessages --all
python manage.py compilemessages
python manage.py celeryd -l INFO &

exec "$@"
