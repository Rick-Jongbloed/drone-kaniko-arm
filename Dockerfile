FROM busybox
ENV PATH /usr/local/bin:/kaniko:/bin;/usr/bin
ENV HOME /root
ENV USER root
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/ 
ADD /kaniko-files /kaniko/
ENTRYPOINT [ "/kaniko/plugin.sh" ]