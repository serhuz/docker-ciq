FROM azul/zulu-openjdk:8

RUN apt-get update -y \
    && apt-get -qqy install unzip wget git ssh tar gzip ca-certificates

RUN useradd -u 1000 -M -s /bin/bash ciq
RUN chown 1000 /opt

USER ciq

# Download and unzip
RUN mkdir /opt/ciq
RUN cd /opt \
    && wget -q http://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.0.6-2018-11-27-33ec0d6.zip -O ciq.zip \
    && unzip ciq.zip -d ciq \
    && rm -f ciq.zip

ENV CIQ_HOME /opt/ciq/bin
ENV PATH ${PATH}:${CIQ_HOME}

USER root
RUN apt-get clean

USER ciq
WORKDIR /home/ciq
VOLUME ["/home/ciq"]

LABEL com.circleci.preserve-entrypoint=true
ENTRYPOINT /bin/bash