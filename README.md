Docker build for ReadTheDocs (RTD)
==================================

This repository provides Dockerfile for [Read The Docs][0]

### Status
Built images are uploaded to [index.docker.io][1]

### Tags

There are currently two tags available depending of the way to distribute content:

 -  `latest`: Which rely on the [`django-manage runserver` command][6], this **should not be used for production**
 -  `gunicorn`: Which serve python files through the [Gunicorn][5] WSGI HTTP server.
    If you are choosing this option, as per [documentation][7], you'll need to use a proxy server in front of Gunicorn workers.

### Quickstart:

 - Install Docker: [http://docs.docker.io/][2]
 - Execute `docker run -d -p 8000:8000 gyzpunk/readthedocs`
 - Browse [http://<your server ip address>:8000/][3]
 - username/password for admin:
   - `username` is `docbuilder`
   - `password` is `docbuilder`

### Docker configuration

Those images will expose the **port** `8000` for the web application (to proxify behind a real webserver in case of gunicorn usage) as well as the `/usr/src/app` **volume** which contains all the django project.

You can also use the following environment variables while building Docker image :
 -  `RTD_PRODUCTION_DOMAIN`: Stands for `PRODUCTION_DOMAIN`in readthedocs settings (can be formed like "{host}:{port}")
 -  `RTD_SLUMBER_PASSWORD`: Stands for `SLUMBER_PASSWORD`in readthedocs settings (will be used as "docbuilder" account password)
 -  `DJANGO_SETTINGS_MODULE`: Django settings module to be used

  [0]: http://readthedocs.org
  [1]: https://index.docker.io/u/shaker/
  [2]: http://docs.docker.io/en/latest/ "docs.docker.io"
  [3]: http://127.0.0.1:8000/
  [4]: https://docs.readthedocs.org/en/latest/settings.html
  [5]: http://gunicorn.org/
  [6]: https://docs.djangoproject.com/en/1.9/ref/django-admin/#runserver-port-or-address-port
  [7]: http://docs.gunicorn.org/en/latest/deploy.html
