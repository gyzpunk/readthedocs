FROM gyzpunk/readthedocs

MAINTAINER  gyzpunk "http://github.com/gyzpunk"

USER root

RUN pip install --no-cache-dir gunicorn

USER rtfd

CMD ["gunicorn", "--workers=4", "--bind=0.0.0.0:8000", "readthedocs.wsgi"]
