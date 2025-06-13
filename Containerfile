# --- build mysqld exporter ---
FROM registry.access.redhat.com/ubi9:latest AS builder
ENV GOPATH=/go
ENV D=/go/src/github.com/prometheus/mysqld-exporter

WORKDIR $D
COPY . $D/

RUN dnf install -y golang make 
RUN make build

# --- end build, create podman_exporter layer ---
FROM registry.access.redhat.com/ubi9:latest

COPY --from=builder /go/src/github.com/prometheus/mysqld-exporter/mysqld-exporter /bin/mysqld-exporter

EXPOSE 9104
USER nobody
ENTRYPOINT [ "/bin/mysqld-exporter" ]
