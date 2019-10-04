FROM ubuntu:bionic
USER root
LABEL maintainer="Naoya Ikeda <n_ikeda@hotmail.com>"
ENV TMPDIR=/tmp
CMD /bin/bash
RUN echo "now building..." && \
    mkdir build/ && \
    cd build && \
    apt update && \
    apt upgrade -y && \
    apt install -y wget build-essential git && \
    wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
    