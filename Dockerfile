FROM kronova/typo3-php:php-7.2

LABEL vendor="kronova.net"
LABEL maintainer="info@kronova.net"

ENV SURF_DOWNLOAD_URL https://github.com/TYPO3/Surf/releases/download/2.0.2/surf.phar
ENV DEPLOYER_VERSION "^6"
ENV DOCUMENT_ROOT /usr/local/apache2/htdocs/public
ENV START_SSH_SERVER true
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.composer/vendor/bin

RUN apt-get update && apt-get install -y openssh-server vim nano parallel rsync

# configure openssh-server
RUN echo "\nPermitRootLogin no\nPasswordAuthentication no\nUsePAM no\n" >> /etc/ssh/sshd_config

# install surf
RUN mkdir /usr/local/surf \
    && curl -L ${SURF_DOWNLOAD_URL} -o /usr/local/surf/surf.phar \
    && chmod +x /usr/local/surf/surf.phar \
    && ln -s /usr/local/surf/surf.phar /usr/local/bin/surf

# install deployer and deployer 3rd party recipes
RUN composer global require deployer/deployer "${DEPLOYER_VERSION}" && composer global require deployer/recipes --dev

# install start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# symlink htdocs folder into home
RUN ln -s /usr/local/apache2/htdocs /home/typo3/htdocs

# cleanup
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/local/apache2/htdocs
CMD ["start.sh"]
