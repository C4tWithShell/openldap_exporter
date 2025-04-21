FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git make
WORKDIR /app

COPY . .
RUN make compile

FROM alpine:3.21.3
RUN addgroup -S appuser -g 1001 && adduser -DH appuser -u 1001 -G appuser
COPY --from=builder /app/target/openldap_exporter /usr/bin/openldap_exporter
USER appuser
EXPOSE 9330
ENTRYPOINT ["openldap_exporter"]