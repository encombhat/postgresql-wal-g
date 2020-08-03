FROM debian:buster AS builder

ARG WAL_URL="https://github.com/wal-g/wal-g/releases/download/v0.2.15/wal-g.linux-amd64.tar.gz"

WORKDIR /data

RUN apt-get update
RUN apt-get install -y wget tar
RUN wget -O wal.tar.gz ${WAL_URL}
RUN tar xf wal.tar.gz
RUN chmod +x wal-g

FROM postgres:12

COPY --from=builder /data/wal-g /usr/local/bin/wal-g
RUN apt-get update && \
    apt-get install ca-certificates && \
    apt-get clean

