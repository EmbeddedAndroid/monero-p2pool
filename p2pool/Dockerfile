FROM alpine:3.17.2 AS builder

RUN apk add --no-cache git gcc g++ cmake make libtool autoconf automake

ARG ref=2ed63ab3acad15bd794eec72e54a18c65a4bd0e2
ARG repo=https://github.com/SChernykh/p2pool

RUN git clone ${repo} /src/p2pool
WORKDIR /src/p2pool
RUN git reset --hard ${ref} && git submodule sync && git submodule update --init --recursive

WORKDIR /src/p2pool/external/src/libzmq
RUN mkdir build && cd build && \
    cmake .. -DENABLE_WS=OFF -DWITH_TLS=OFF -DENABLE_CURVE=OFF && \
    make -j$(nproc)

WORKDIR /src/p2pool/external/src/libuv
RUN mkdir build && cd build && \
    cmake .. && \
    make -j$(nproc)

WORKDIR /src/p2pool/external/src/curl
RUN autoreconf -fi && \
    ./configure --without-ssl --without-hyper --without-zlib --without-brotli --without-zstd --without-default-ssl-backend --without-ca-bundle --without-ca-path --without-ca-fallback --without-libpsl --without-libgsasl --without-librtmp --without-winidn --without-libidn2 --without-nghttp2 --without-ngtcp2 --without-nghttp3 --without-quiche --without-msh3 --without-zsh-functions-dir --without-fish-functions-dir --disable-ftp --disable-file --disable-ldap --disable-ldaps --disable-rtsp --disable-proxy --disable-dict --disable-telnet --disable-tftp --disable-pop3 --disable-imap --disable-smb --disable-smtp --disable-gopher --disable-mqtt --disable-manual --disable-ntlm --disable-ntlm-wb --disable-tls-srp --disable-unix-sockets --disable-cookies --disable-socketpair --disable-doh --disable-dateparse --disable-netrc --disable-progress-meter --disable-dnsshuffle --disable-hsts --disable-alt-svc --disable-ares && \
    make -j$(nproc)

WORKDIR /src/p2pool

RUN mkdir build && cd build && \
    CFLAGS="-march=native -mtune=native -Ofast -Wno-error=unused-variable" CXXFLAGS="-march=native -mtune=native -Ofast -Wno-error=unused-variable" \
    cmake .. -DSTATIC_BINARY=ON && \
    make -j$(nproc)

FROM alpine:3.17.2

RUN apk add --no-cache curl jq bash

RUN mkdir -p /p2pool

COPY --from=builder /src/p2pool/build/p2pool /p2pool/p2pool

EXPOSE 3333 37889

WORKDIR /p2pool/data

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
