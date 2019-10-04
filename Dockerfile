FROM ubuntu:bionic
USER root
LABEL maintainer="Naoya Ikeda <n_ikeda@hotmail.com>"
ENV TMPDIR=/tmp
ENV ACCEPT_EULA=Y
ENV DEBIAN_FRONTEND=noninteractive
ARG DEFAULT_USER=user
ARG DEFAULT_SHELL=/bin/bash
ARG DEFAULT_GID="100"
ARG DEFAULT_UID="1000"
ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=1.2.0
ENV CONDA_DIR=/opt/anaconda3
ENV SHELL=/bin/bash
ENV DEFAULT_UID=${DEFAULT_UID}
ENV DEFAULT_GID=${DEFAULT_GID}
CMD /bin/bash
WORKDIR /root
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
    bash ./Anaconda3-2019.07-Linux-x86_64.sh -b -p ${CONDA_DIR} && \
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
RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    echo "926ced5dec5d726ed0d2919e849ff084a320882fb67ab048385849f9483afc47 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia
ENV PATH /opt/anaconda3/bin:$PATH
RUN useradd -m -s ${DEFAULT_SHELL} -N -u ${DEFAULT_UID} ${DEFAULT_USER} && \
    gpasswd -a ${DEFAULT_USER} sudo && \
    echo "${DEFAULT_USER}:user" | chpasswd
RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    mkdir ${JULIA_PKGDIR} && \
    chown ${DEFAULT_USER} ${JULIA_PKGDIR}
RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add("HDF5")'
