FROM golang:alpine
MAINTAINER "Wojciech Puchta <wojciech.puchta@hicron.com>"

# Configure the Terraform version here
ENV TERRAFORM_VERSION=0.11.13

RUN apk add --update git bash openssh

# install azure cli
RUN apk update \
  && apk add bash py-pip make \
  && apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev \
  && pip install azure-cli \
  && apk del --purge build

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ \
  && git checkout v${TERRAFORM_VERSION} \
  && /bin/bash scripts/build.sh

# install AzCopy

RUN go get -u github.com/Azure/azure-storage-azcopy
WORKDIR $GOPATH/src/github.com/Azure/azure-storage-azcopy
ENV GOOS linux
ENV GARCH amd64
ENV CGO_ENABLED 0
RUN go install -v -a -installsuffix cgo \
  && cp $GOPATH/bin/azure-storage-azcopy /bin/azcopy 

# Start in root's home
WORKDIR /root
