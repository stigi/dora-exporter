FROM golang:1.19.2 AS builder
WORKDIR /usr/local/go/src/dora-exporter
COPY go.mod ./
COPY go.sum ./
COPY Makefile ./
COPY pkg/ pkg/
COPY cmd/ cmd/
RUN make deps
RUN make dist

FROM alpine:3.16.2
LABEL org.opencontainers.image.title="dora-exporter"
LABEL org.opencontainers.image.authors="Maksym Prokopov <mprokopov@gmaio.com>"
LABEL org.opencontainers.image.url="https://github.com/mprokopov/dora-exporter"
LABEL org.opencontainers.image.source="https://github.com/mprokopov/dora-exporter"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"
LABEL org.opencontainers.image.description="Prometheus exporter GitHub and Jira Integrated DORA metrics"

COPY --from=builder /usr/local/go/src/dora-exporter/dora-exporter .
COPY configs/config.yml.dist config.yml

EXPOSE 8090

ENTRYPOINT ["./dora-exporter"]
