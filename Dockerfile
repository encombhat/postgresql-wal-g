FROM golang:1.12-alpine AS builder

ARG WAL_URL="https://github.com/wal-g/wal-g.git"
ARG WAL_VERSION=v0.2.16

WORKDIR /data
RUN apk add --no-cache wget cmake git build-base bash
RUN git clone ${WAL_URL}

WORKDIR /data/wal-g
RUN git checkout ${WAL_VERSION}
RUN make install
RUN make deps
RUN make pg_build
RUN install main/pg/wal-g /

WORKDIR /data
RUN /wal-g --help

FROM postgres:12-alpine

COPY --from=builder /wal-g /usr/local/bin/wal-g
RUN apk add --no-cache ca-certificates

