FROM azul/zulu-openjdk:8

LABEL com.circleci.preserve-entrypoint=true
ENTRYPOINT /bin/bash

RUN apt-get update -y \
    && apt-get -qqy install unzip wget git ssh tar gzip ca-certificates \
    && apt-get clean

RUN useradd -u 1000 -M -s /bin/bash ciq
RUN mkdir /opt/ciq && chown 1000 /opt/ciq
RUN mkdir /home/ciq && chown 1000 /home/ciq

ENV CIQ_HOME /opt/ciq/bin
ENV PATH ${PATH}:${CIQ_HOME}

USER ciq

# Download and unzip
RUN cd /home/ciq \
    && wget -q \
    https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.1.9-2020-06-24-1cc9d3a70.zip \
    -O ciq.zip \
    && unzip ciq.zip -d /opt/ciq \
    && rm -f ciq.zip

WORKDIR /home/ciq
VOLUME ["/home/ciq"]
