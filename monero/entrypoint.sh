#!/bin/bash

if ! curl --fail --connect-timeout 10 --verbose https://gui.xmr.pm/files/block.txt --output /var/monero/block.txt; then
  touch /var/monero/block.txt
fi

exec "/monerod" \
--data-dir /var/monero \
--ban-list /var/monero/block.txt \
--zmq-pub=tcp://0.0.0.0:18083 --rpc-bind-ip=0.0.0.0 --rpc-bind-port 18081 \
--non-interactive --confirm-external-bind --restricted-rpc --allow-local-ip --no-igd \
--fast-block-sync 1 --prep-blocks-threads $(nproc) --sync-pruned-blocks --prune-blockchain --check-updates disabled \
--disable-dns-checkpoints \
--in-peers 32 \
--out-peers 32 \
"$@"
