FROM --platform=$BUILDPLATFORM ubuntu:22.04 as build

ENV PREFIX=/usr/local/firebird

ENV VOLUME=/firebird

ENV FBURL=https://github.com/FirebirdSQL/firebird/releases/download/v5.0.0/Firebird-5.0.0.1306-0-linux-x64.tar.gz

ENV DBPATH=/firebird/data

COPY build.sh ./build.sh

RUN chmod +x ./build.sh && \
    sync && \
    ./build.sh  && \
    rm -f ./build.sh  

FROM --platform=$TARGETPLATFORM ubuntu:22.04

ENV PREFIX=/opt/firebird
ENV VOLUME=/firebird
ENV DEBIAN_FRONTEND noninteractive
ENV DBPATH=/firebird/data

ENV FIREBIRD_DATABASE='teste.fdb'
ENV FIREBIRD_PASSWORD='masterkey'
ENV FIREBIRD_USER='PAULO'
ENV ISC_PASSWORD='masterkey'

COPY --from=build /home/firebird/firebird.tar.gz /home/firebird/firebird.tar.gz

COPY install.sh ./install.sh

RUN chmod +x ./install.sh && \
    sync && \
    ./install.sh && \
    rm -f ./install.sh

VOLUME ["/firebird"]

COPY docker-entry.sh ${PREFIX}/docker-entrypoint.sh

RUN chmod +x ${PREFIX}/docker-entrypoint.sh

EXPOSE 3050/tcp

WORKDIR /

CMD ["firebird"]

ENTRYPOINT [ "/opt/firebird/docker-entrypoint.sh" ]
