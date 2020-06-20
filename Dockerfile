FROM alpine as BASE

# integrate vault
RUN wget https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip \
  && unzip vault_1.2.3_linux_amd64.zip

FROM gcr.io/kaniko-project/executor:debug

COPY --from=BASE /vault /usr/local/bin/
