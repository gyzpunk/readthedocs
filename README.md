Docker build for ReadTheDocs (RTD)
==================================

This repository provides Dockerfile for [Read The Docs][0]

### Status
Built images are uploaded to [index.docker.io][1]

### Usage:

 - Install Docker: [http://docs.docker.io/][2]
 - Execute `docker run -d --name rtfd -p 8000:8000 gyzpunk/readthedocs`
 - Browse [http://&lt;your server ip address&gt;:8000/][3]
 - Stop and start again
   - `docker stop rtfd`
   - `docker start rtfd`
 - username/password for admin:
   - `username` is `docbuilder`
   - `password` is `docbuilder`

### ReadTheDocs configuration
You can customize your RTD instance by modifying the file `files/local_settings.py`.
You'll find many guidelines about useful settings [here][4]

You can also use the following arguments while building Docker image :
 -  `domain`: Stands for `PRODUCTION_DOMAIN`in readthedocs settings (can be formed like "{host}:{port}")
 -  `slumber_password`: Stands for `SLUMBER_PASSWORD`in readthedocs settings (will be used as "docbuilder" account password)
 -  `secretkey`: `SECRET_KEY` Django setting

  [0]: http://readthedocs.org
  [1]: https://index.docker.io/u/shaker/
  [2]: http://docs.docker.io/en/latest/ "docs.docker.io"
  [3]: http://127.0.0.1:8000/
  [4]: https://docs.readthedocs.org/en/latest/settings.html
