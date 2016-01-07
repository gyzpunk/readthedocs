FROM python:2

MAINTAINER  gyzpunk "http://github.com/gyzpunk"

ENV RTD_PATH="/usr/src/app" \
	RTD_PRODUCTION_DOMAIN="localhost:8000" \
	RTD_SLUMBER_PASSWORD="docbuilder" \
	SECRET_KEY="changemeplease" \
	DJANGO_SETTINGS_MODULE="readthedocs.settings.sqlite" \
	APP_DATA_PATH="/var/app-data" \
	APP_LOGS_PATH="/var/app-logs"

# Install necessary system packages
RUN export DEBIAN_FRONTEND="noninteractive" \
	&& curl -sL https://deb.nodesource.com/setup_4.x | bash - \
	&& apt-get update && apt-get install -y \
		locales \
		unzip \
		libxml2-dev \
		libxslt1-dev \
		libevent-dev \
		build-essential \
		zlib1g-dev \
		doxygen \
		texlive-latex-base \
		texlive-fonts-recommended \
		dvipng \
		graphviz \
		nodejs \

	&& export LANGUAGE=en_US.UTF-8 \
	&& export LANG=en_US.UTF-8 \
	&& export LC_ALL=en_US.UTF-8 \
	&& locale-gen en_US.UTF-8 \
	&& dpkg-reconfigure locales \

	# Install CMAP for pdflatex
	&& curl -L -o /tmp/cmap.zip http://mirrors.ctan.org/macros/latex/contrib/cmap.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/cmap.zip \
	&& curl -L -o /tmp/fancybox.zip http://mirrors.ctan.org/macros/latex/contrib/fancybox.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/fancybox.zip \
	&& curl -L -o /tmp/titlesec.zip http://mirrors.ctan.org/macros/latex/contrib/titlesec.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/titlesec.zip \
	&& curl -L -o /tmp/framed.zip http://mirrors.ctan.org/macros/latex/contrib/framed.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/framed.zip \
	&& curl -L -o /tmp/fancyvrb.zip http://mirrors.ctan.org/macros/latex/contrib/fancyvrb.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/fancyvrb.zip && cd /usr/share/texmf/tex/latex/fancyvrb && latex fancyvrb.ins && cd - \
	&& curl -L -o /tmp/threeparttable.zip http://mirrors.ctan.org/macros/latex/contrib/threeparttable.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/threeparttable.zip \
	&& curl -L -o /tmp/mdwtools.zip http://mirrors.ctan.org/macros/latex/contrib/mdwtools.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/mdwtools.zip \
	&& curl -L -o /tmp/wrapfig.zip http://mirrors.ctan.org/macros/latex/contrib/wrapfig.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/wrapfig.zip \
	&& curl -L -o /tmp/parskip.zip http://mirrors.ctan.org/macros/latex/contrib/parskip.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/parskip.zip \
	&& curl -L -o /tmp/upquote.zip http://mirrors.ctan.org/macros/latex/contrib/upquote.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/upquote.zip \
	&& curl -L -o /tmp/float.zip http://mirrors.ctan.org/macros/latex/contrib/float.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/float.zip && cd /usr/share/texmf/tex/latex/float && latex float.ins && cd - \
	&& curl -L -o /tmp/multirow.zip http://mirrors.ctan.org/macros/latex/contrib/multirow.zip \
	&& unzip -d /usr/share/texmf/tex/latex/ /tmp/multirow.zip \
	&& texhash \

	&& npm install -g bower gulp \

	&& mkdir -p ${APP_DATA_PATH} ${APP_LOGS_PATH} ${RTD_PATH} \
	&& cd ${RTD_PATH} \
	&& curl -L -o /tmp/rtfd.zip https://github.com/rtfd/readthedocs.org/archive/master.zip \
	&& unzip -d . /tmp/rtfd.zip && mv readthedocs.org-master/* . && rm -r readthedocs.org-master \
	&& pip install --no-cache-dir sphinx \
	&& pip install --no-cache-dir -r requirements.txt \

	# Clean up everything
	&& rm -rf /tmp/* \
	&& apt-get purge -y unzip \
	&& apt-get purge -y $(dpkg-query -f '${binary:Package} ' -W '*-doc') \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /${RTD_PATH}

#RUN pip install gunicorn

# Create dedicated user to run RTFD
RUN groupadd -r rtfd \
	&& useradd -m -r -g rtfd rtfd \
	&& chown -R rtfd:rtfd . ${APP_DATA_PATH} ${APP_LOGS_PATH}
USER rtfd

RUN npm install \
	&& bower install \
	&& gulp build \
	&& gulp vendor \

	# Prepare DB
 	&& ./manage.py syncdb --noinput \
	&& ./manage.py migrate \
	&& echo "from django.contrib.auth.models import User; import os; User.objects.create_superuser('docbuilder', 'docbuilder@localhost', os.getenv('RTD_SLUMBER_PASSWORD'))" | ./manage.py shell \

	# Prepare configuration
	&& echo "import os\nSLUMBER_USERNAME = 'docbuilder'\nSLUMBER_PASSWORD = os.getenv('RTD_SLUMBER_PASSWORD', 'docbuilder')\nPRODUCTION_DOMAIN = os.getenv('RTD_PRODUCTION_DOMAIN', 'localhost:8000')" >> readthedocs/settings/local_settings.py \

	# Prepare volumes
	&& path=${APP_DATA_PATH}/db && mkdir -p $path && mv dev.db $path && ln -s $path/dev.db dev.db \
	&& path=${APP_LOGS_PATH} && mkdir -p $path && mv logs/* $path && rm -rf logs && ln -s $path logs

VOLUME ["/var/app-data", "/var/app-logs"]

# Issue with static files collection to activate gunicorn
#ENTRYPOINT ["gunicorn", "--workers=4", "--bind=0.0.0.0:8000", "readthedocs.wsgi"]
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
