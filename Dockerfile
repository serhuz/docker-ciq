FROM azul/zulu-openjdk:8

LABEL com.circleci.preserve-entrypoint=true
ENTRYPOINT /bin/bash

RUN apt-get update -y \
    && apt-get -qqy install unzip wget git ssh tar gzip ca-certificates

RUN useradd -u 1000 -M -s /bin/bash ciq
RUN chown 1000 /opt

USER ciq

# Download and unzip
RUN mkdir /opt/ciq
RUN cd /opt \
    && wget -q \
    https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.0.12-2019-06-12-77ed6f47e.zip \
    -O ciq.zip \
    && unzip ciq.zip -d ciq \
    && rm -f ciq.zip

ENV CIQ_HOME /opt/ciq/bin
ENV PATH ${PATH}:${CIQ_HOME}

USER root
RUN apt-get clean
RUN mkdir /home/ciq && chown ciq /home/ciq

USER ciq
WORKDIR /home/ciq
VOLUME ["/home/ciq"]
