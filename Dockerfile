FROM alpine:edge

RUN apk add --no-cache dnscrypt-proxy drill doas

RUN adduser -D alpine -G wheel
RUN echo 'permit nopass :wheel' > /etc/doas.d/doas.conf

COPY dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml

USER alpine

EXPOSE 5353/tcp
EXPOSE 5353/udp

HEALTHCHECK --interval=10s --timeout=10s --start-period=5s --retries=3 CMD drill -p 5353 @127.0.0.1 cloudflare.com || exit 1

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
