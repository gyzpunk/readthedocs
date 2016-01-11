FROM gyzpunk/readthedocs

MAINTAINER  gyzpunk "http://github.com/gyzpunk"

USER root

RUN pip install --no-cache-dir -r requirements/deploy.txt

USER rtfd

ENTRYPOINT ["gunicorn", "--workers=4", "--bind=0.0.0.0:8000", "--access-logfile=-", "--error-logfile=-", "readthedocs.wsgi"]
