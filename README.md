# Monero + P2Pool

Quick and dirty Alpine based Monero + P2Pool service

## Monero

Version: `v0.18.3.1`

## P2Pool

Version: `v3.7`

## Build

```
docker compose build
```

## Run

```
docker compose up -d
```

## Logs

```
docker logs -f monero
docker logs -f p2pool
```

## Stop

```
docker compose down
```
