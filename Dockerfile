# AWS is nog supported
# GCR is not supported

FROM busybox

# have to find out how to do this
#COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/out/executor /kaniko/executor 


# Declare /busybox as a volume to get it automatically whitelisted # how does this work. Why?
#VOLUME /busybox
#COPY files/ca-certificates.crt /kaniko/ssl/certs/
#COPY deploy/config.json /kaniko/.docker/config.json


ENV PATH /usr/local/bin:/kaniko:/busybox
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/

ENV HOME /root
ENV USER root
ENV SSL_CERT_DIR=/kaniko/ssl/certs

ENV DOCKER_CONFIG /kaniko/.docker/ 


# will copy the files from the build container instead of using the executor:debug image

# add the wrapper which acts as a drone plugin
COPY plugin.sh /kaniko/plugin.sh
ENTRYPOINT [ "/kaniko/plugin.sh" ]