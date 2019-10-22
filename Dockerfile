FROM golang:alpine
MAINTAINER "Wojciech Puchta <wojciech.puchta@hicron.com>"

ENV TERRAFORM_VERSION=0.12.12
ENV TF_DEV=true
ENV TF_RELEASE=true

RUN apk add --update git bash openssh

# install azure cli
RUN apk update \
  && apk add bash py-pip make \
  && apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev \
  && pip install azure-cli \
  && apk del --purge build

# install terraform
WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ \
  && git checkout v${TERRAFORM_VERSION} \
  && /bin/bash scripts/build.sh

# install AzCopy
RUN apk add libc6-compat \
  && wget https://aka.ms/downloadazcopy-v10-linux -O /tmp/azcopy \
  && tar -zxvf /tmp/azcopy -C /tmp/ \
  && mv /tmp/azcopy_linux_amd64*/azcopy /bin/azcopy

# install cli utils
RUN apk add vim curl jq ansible
COPY .bashrc /root/.bashrc
COPY config /etc/ssh/ssh_config

WORKDIR /root
CMD /bin/bash
