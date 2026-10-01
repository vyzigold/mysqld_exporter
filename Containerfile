# --- build mysqld exporter ---
FROM registry.access.redhat.com/ubi10:latest AS builder
ENV GOPATH=/go
ENV D=/go/src/github.com/prometheus/mysqld_exporter

WORKDIR $D
COPY . $D/

RUN dnf install -y golang make 
RUN make build

# --- end build, create podman_exporter layer ---
FROM registry.access.redhat.com/ubi10:latest

COPY --from=builder /go/src/github.com/prometheus/mysqld_exporter/mysqld_exporter /bin/mysqld_exporter

EXPOSE 9104
USER nobody
ENTRYPOINT [ "/bin/mysqld_exporter" ]
