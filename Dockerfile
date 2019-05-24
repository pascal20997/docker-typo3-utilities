FROM kronova/typo3-php:latest

LABEL vendor="kronova.net"
LABEL maintainer="info@kronova.net"

ENV SURF_DOWNLOAD_URL https://github.com/TYPO3/Surf/releases/download/2.0.0-beta10/surf.phar
ENV INSTALL_TYPO3 true
ENV TYPO3_VERSION "^9.5"
ENV DOCUMENT_ROOT /usr/local/apache2/htdocs/public
ENV START_SSH_SERVER true

RUN apt-get update && apt-get install -y openssh-server vim nano parallel wkhtmltopdf

# configure openssh-server
RUN echo "\nPermitRootLogin no\nPasswordAuthentication no\nUsePAM no\n" >> /etc/ssh/sshd_config

# install surf
RUN mkdir /usr/local/surf \
    && curl -L ${SURF_DOWNLOAD_URL} -o /usr/local/surf/surf.phar \
    && chmod +x /usr/local/surf/surf.phar \
    && ln -s /usr/local/surf/surf.phar /usr/local/bin/surf

# install deployer
RUN curl -LO https://deployer.org/deployer.phar \
    && mv deployer.phar /usr/local/bin/dep \
    && chmod +x /usr/local/bin/dep

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
