FROM registry.access.redhat.com/ubi8/ubi:latest

RUN dnf -y update
RUN dnf -y module install nodejs:16
RUN dnf -y install curl openssl openssl-devel gcc gcc-c++ make cyrus-sasl-devel cmake libpq-devel perl

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.58.0

ENV PATH "$PATH:$HOME/.cargo/bin"

RUN mkdir /out

VOLUME /out

