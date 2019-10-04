FROM ubuntu:bionic
USER root
LABEL maintainer="Naoya Ikeda <n_ikeda@hotmail.com>"
ENV TMPDIR=/tmp
ENV ACCEPT_EULA=Y
ENV DEBIAN_FRONTEND=noninteractive
CMD /bin/bash
RUN echo "now building..." && \
    mkdir build/ && \
    cd build && \
    apt update && \
    apt install -y git gnupg curl wget make swig libboost-dev pandoc cmake gfortran unzip libsm6 pandoc libjpeg-dev libgsl-dev libunwind-dev libgmp3-dev libfontconfig1-dev libudunits2-dev libgeos-dev libmagick++-dev && \
    apt install -y gdal-bin gdal-data libgdal-dev && \
    apt install -y lsb-release build-essential libssl-dev libc6-dev libicu-dev apt-file libxrender1 libglib2.0-dev libcairo2-dev libtiff-dev && \
    apt install -y texlive-latex-base texlive-latex-extra texlive-fonts-extra texlive-fonts-recommended texlive-generic-recommended && \
    apt install -y fonts-ipafont-gothic fonts-ipafont-mincho && \
    apt install -y vim default-jdk libv8-3.14-dev libxml2-dev libcurl4-openssl-dev libssl-dev && \
    apt install -y xorg libx11-dev libglu1-mesa-dev libfreetype6-dev && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt update && \
    apt upgrade -y && \
    wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh && \
    bash ./Anaconda3-2019.07-Linux-x86_64.sh -b -p /opt/anaconda3 && \
# for compile quick hack
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    wget https://github.com/unicode-org/icu/archive/release-58-3.tar.gz && \
    tar xvzf release-58-3.tar.gz && \
    cd icu-release-58-3/icu4c/source && \
    ./configure && \
    make && \
    make install && \
    ldconfig /etc/ld.so.conf.d && \
    unlink /usr/include/locale.h
ENV PATH /opt/anaconda3/bin:$PATH
