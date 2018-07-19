FROM ubuntu:16.04
MAINTAINER devopstenerife@gmail.com

# Modified from James Wickett's Security Test Course on Lynda

ARG ARACHNI_VERSION=arachni-1.5.1-0.5.12

# Install Ruby and other OS stuff
RUN apt-get update && \
    apt-get install -y build-essential \
      bzip2 \
      ca-certificates \
      curl \
      gcc \
      git \
      libcurl3 \
      libcurl4-openssl-dev \
      wget \
      zlib1g-dev \
      libfontconfig \
      libxml2-dev \
      libxslt1-dev \
      make \
      python-pip \
      python2.7 \
      python2.7-dev \
      ruby \
      ruby-dev \
      ruby-bundler && \
    rm -rf /var/lib/apt/lists/*

# Install Gauntlt
RUN gem install ffi -v 1.9.18
RUN gem install gauntlt --no-rdoc --no-ri
RUN gem install zapr

# Install Attack tools
WORKDIR /opt

# arachni
RUN wget https://github.com/Arachni/arachni/releases/download/v1.5.1/${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf ${ARACHNI_VERSION}-linux-x86_64.tar.gz > /dev/null && \
    mv ${ARACHNI_VERSION} /usr/local && \
    ln -s /usr/local/${ARACHNI_VERSION}/bin/* /usr/local/bin/

# Nikto
RUN apt-get update && \
    apt-get install -y libtimedate-perl \
      libnet-ssleay-perl && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/sullo/nikto.git && \
    cd nikto/program && \
    echo "EXECDIR=/opt/nikto/program" >> nikto.conf && \
    ln -s /opt/nikto/program/nikto.conf /etc/nikto.conf && \
    chmod +x nikto.pl && \
    ln -s /opt/nikto/program/nikto.pl /usr/local/bin/nikto

# sqlmap
WORKDIR /opt
ENV SQLMAP_PATH /opt/sqlmap/sqlmap.py
RUN git clone --depth=1 https://github.com/sqlmapproject/sqlmap.git

# dirb
RUN wget -O dirb222.tar.gz https://downloads.sourceforge.net/project/dirb/dirb/2.22/dirb222.tar.gz && \
    tar xvfz dirb222.tar.gz > /dev/null && \
    cd dirb222 && \
    chmod 755 ./configure && \
    ./configure && \
    make && \
    ln -s /opt/dirb222/dirb /usr/local/bin/dirb

ENV DIRB_WORDLISTS /opt/dirb222/wordlists

# nmap
RUN apt-get update && \
    apt-get install -y nmap && \
    rm -rf /var/lib/apt/lists/*

# owasp-zap
RUN echo 'deb [trusted=yes] http://download.opensuse.org/repositories/home:/cabelo/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/home:cabelo.list && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated owasp-zap	

ENV ZAP_PATH=/usr/share/owasp-zap

# zap-cli
RUN pip install --disable-pip-version-check zapcli

RUN mkdir -p /working

VOLUME /working

WORKDIR /working

ENTRYPOINT [ "/usr/local/bin/gauntlt" ]
