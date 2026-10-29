# Node.js Microservices V1 — Docker DNS

Minimal runnable demo containing:
- API Gateway on `http://localhost:8080`
- ProPulse API (`propulse:3001`) with Postgres and Redis
- Reels video read API (`streamapi:3010`)
- Docker Compose orchestration and Docker DNS service discovery

There is no custom registry container. Docker Compose creates the `backend` network and Docker DNS resolves service names such as `propulse` and `streamapi` for containers attached to that network.

## Requirements
- Docker Engine/Desktop with Docker Compose v2

## Run

```bash
docker compose up --build -d
docker compose ps
docker compose logs -f
```

## Test

```bash
curl http://localhost:8080/health
curl http://localhost:8080/routes
curl -sD - http://localhost:8080/api/propulse/health
curl -sD - http://localhost:8080/api/stream/health
curl -sD - http://localhost:8080/api/propulse/reels
curl -s 'http://localhost:8080/socket.io/?EIO=4&transport=polling'
```

The gateway removes `/api/propulse` before forwarding, so `/api/propulse/posts` reaches `/posts` on ProPulse. Point the app at `http://localhost:8080/api/propulse`. Socket.IO stays on `http://localhost:8080/socket.io`.

`GET /api/stream/health` is the Reels stream health check. It reports the container in `instance`, plus database and Redis in `checks`. `GET /api/propulse/reels` and `GET /api/propulse/reels/:id` are the Reels video reads. Those requests go to `streamapi`. Every other ProPulse route stays on `propulse`. The `x-instance` header names the container that answered.

`/api/propulse/health` returns the container hostname in `instance` and `x-instance`. The gateway also sets `x-upstream-replica`.

## Scale and load distribution

Docker Compose can run several containers for the same service. The gateway resolves every replica through Docker DNS, health-checks them, and spreads requests across the healthy ones.

```bash
docker compose up --build -d --scale streamapi=3
```

Replica counts can also be declared up front:

```bash
STREAMAPI_REPLICAS=3 docker compose up --build -d
```

Changing the count later is picked up on the next refresh (default 5 seconds). No gateway restart is required.

```bash
docker compose up -d --scale streamapi=5 --no-recreate
curl http://localhost:8080/balance
```

`GET /balance` shows the active strategy, replica health, weight, in-flight requests, and the share of completed requests.

Default strategy is `round-robin`. Switch it at runtime:

```bash
curl -X PUT http://localhost:8080/balance \
  -H 'content-type: application/json' \
  -d '{"strategy":"least-connections"}'
```

`least-connections` prefers the replica with the fewest in-flight requests and rotates ties. `weighted` uses integer weights from 0 to 100. Weight `0` drains a replica. Weights survive refreshes for replicas that keep the same address.

```bash
curl -X PUT http://localhost:8080/balance \
  -H 'content-type: application/json' \
  -d '{"strategy":"weighted","weights":[{"service":"streamapi","address":"172.19.0.5","weight":3}]}'
```

Set the initial strategy with `LB_STRATEGY` (`round-robin`, `least-connections`, or `weighted`). If the chosen replica refuses the connection, the gateway tries another healthy replica. Leave `PROPULSE_REPLICAS` at 1: scheduled jobs and live presence run inside that process.

## How Docker DNS is used

The gateway receives these internal base URLs from Compose:

- `PROPULSE_URL=http://propulse:3001`
- `STREAMAPI_URL=http://streamapi:3010`

Docker DNS resolves `propulse` and `streamapi` to every replica address on the shared `backend` network. The gateway refreshes that list, drops replicas that fail `/health`, and distributes requests itself. No service registration or heartbeat code is required for this starter.

ProPulse keeps its own routes, database, and Redis cache. The gateway streams those requests, including file uploads, and forwards Socket.IO on `/socket.io`. Secrets stay in `propulse_backend/.env`; Compose overrides `DATABASE_URL` and `REDIS_URL` so the container uses the Compose Postgres and Redis.

## Useful commands

```bash
docker compose ps
docker compose logs -f gateway
docker compose logs -f propulse
docker compose logs -f streamapi
docker compose down
```

## Notes and limitations

- This is a learning/demo gateway, not a hardened production reverse proxy. For production, consider NGINX, Envoy, Kong, or Traefik, and configure authentication, authorization, rate limiting, TLS, observability, robust health handling, and request streaming.
- ProPulse and streamapi are streamed through the gateway, so uploads and Socket.IO pass through. Large media should still go to object storage when the route is built that way.
- Docker DNS provides service-name resolution, not every feature of a dedicated registry. If you later need advanced health-aware discovery across environments, reassess the architecture.
- No Kafka is included.
