FROM arm32v7/busybox
WORKDIR /
ENV PATH /kaniko:/bin
ENV HOME /root
ENV USER root
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ADD /kaniko-files /kaniko/
ENTRYPOINT [ "/kaniko/plugin.sh" ]