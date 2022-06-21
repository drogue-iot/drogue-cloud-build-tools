FROM registry.access.redhat.com/ubi9/ubi:latest

RUN dnf -y update
RUN dnf -y install nodejs
RUN dnf -y install curl-minimal openssl openssl-devel gcc gcc-c++ make cyrus-sasl-devel cmake libpq-devel perl
RUN dnf -y install git

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.61.0

ENV PATH "$PATH:$HOME/.cargo/bin"

RUN mkdir /out

VOLUME /out

