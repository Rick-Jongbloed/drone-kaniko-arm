FROM arm32v7/busybox
ENV PATH /kaniko:/bin
ENV HOME /root
ENV USER root
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ADD /kaniko-files /kaniko/
ENTRYPOINT [ "/kaniko/plugin.sh" ]



FROM scratch
COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/out/executor /kaniko/executor
COPY --from=0 /usr/local/bin/docker-credential-gcr /kaniko/docker-credential-gcr
COPY --from=0 /go/src/github.com/awslabs/amazon-ecr-credential-helper/bin/linux-amd64/docker-credential-ecr-login /kaniko/docker-credential-ecr-login
COPY --from=0 /usr/local/bin/docker-credential-acr-linux /kaniko/docker-credential-acr-linux
COPY files/ca-certificates.crt /kaniko/ssl/certs/
COPY --from=0 /root/.docker/config.json /kaniko/.docker/config.json
ENV HOME /root
ENV USER /root
ENV PATH /usr/local/bin:/kaniko
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json
WORKDIR /workspace
RUN ["docker-credential-gcr", "config", "--token-source=env"]
ENTRYPOINT ["/kaniko/executor"]