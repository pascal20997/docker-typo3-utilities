FROM kronova/typo3-php:latest

LABEL vendor="kronova.net"
LABEL maintainer="info@kronova.net"

ENV SURF_DOWNLOAD_URL https://github.com/TYPO3/Surf/releases/download/2.0.0-beta10/surf.phar
ENV INSTALL_TYPO3 true
ENV TYPO3_VERSION "^9.5"
ENV DOCUMENT_ROOT /usr/local/apache2/htdocs/public

RUN apt-get update && apt-get install -y openssh-server vim nano cron

# configure openssh-server
RUN echo "\nPermitRootLogin no\nPasswordAuthentication no\nUsePAM no\n" >> /etc/ssh/sshd_config

# auto start openssh-server
RUN update-rc.d ssh defaults

# install surf
RUN mkdir /usr/local/surf \
    && curl -L ${SURF_DOWNLOAD_URL} -o /usr/local/surf/surf.phar \
    && chmod +x /usr/local/surf/surf.phar \
    && ln -s /usr/local/surf/surf.phar /usr/local/bin/surf

# install start script
COPY start /usr/local/bin/start
RUN chmod +x /usr/local/bin/start

# add log file for cronjob
RUN touch /var/log/cronjob && chown daemon:daemon /var/log/cronjob

# add crontab
RUN (crontab -l ; echo "*/5 * * * * typo3 /opt/cronjob >> /var/log/cronjob") | crontab -

# cleanup
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/local/apache2/htdocs
USER daemon
CMD ["start"]
