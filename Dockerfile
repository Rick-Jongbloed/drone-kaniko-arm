FROM arm32v7/busybox
#FROM busybox:glibc
ENV PATH /kaniko:/bin
ENV HOME /root
ENV USER root
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/ 
ADD /kaniko-files /kaniko/
#RUN chmod +rwx /kaniko/plugin.sh
ENTRYPOINT [ "/kaniko/plugin.sh" ]
#ENTRYPOINT [ "/kaniko/executor" ]