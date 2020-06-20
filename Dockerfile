FROM alpine:3.12.0 as BASE

# integrate vault
RUN wget https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip \
  && unzip vault_1.2.3_linux_amd64.zip

FROM gcr.io/kaniko-project/executor:debug as kaniko

FROM alpine:3.12.0

RUN apk update && \
  apk upgrade && \
  apk add --no-cache bash git util-linux grep \
  && rm -rf /var/lib/apt/lists/*

# Should be put after above installations
COPY --from=kaniko /kaniko/executor /kaniko/
COPY --from=BASE /vault /usr/local/bin/

ENV HOME /root
ENV USER /root
ENV PATH /usr/local/bin:/kaniko:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
WORKDIR /workspace

ENTRYPOINT ["/kaniko/executor"]
