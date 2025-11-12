## install


```shell
mkdir teable
cd teable
```

```text docker-compose.yaml
services:
  teable:
    image: ghcr.io/teableio/teable:latest
    restart: always
    ports:
      - '3000:3000'
    volumes:
      - teable-data:/app/.assets:rw
    env_file:
      - .env
    environment:
      - NEXT_ENV_IMAGES_ALL_REMOTE=true
    networks:
      - teable
    depends_on:
      teable-db:
        condition: service_healthy
      teable-cache:
        condition: service_healthy
    healthcheck:
      test: ['CMD', 'curl', '-f', 'http://localhost:3000/health']
      start_period: 5s
      interval: 5s
      timeout: 3s
      retries: 3

  teable-db:
    image: swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/postgres:18.0
    restart: always
    volumes:
      - teable-db:/var/lib/postgresql/data:rw
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    networks:
      - teable
    healthcheck:
      test: ['CMD-SHELL', "sh -c 'pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}'"]
      interval: 10s
      timeout: 3s
      retries: 3

  teable-cache:
    image: swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/redis:7.2.4
    restart: always
    volumes:
      - teable-cache:/data:rw
    networks:
      - teable
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    healthcheck:
      test: ['CMD', 'redis-cli', '--raw', 'incr', 'ping']
      interval: 10s
      timeout: 3s
      retries: 3

networks:
  teable:
    name: teable-network

volumes:
  teable-db: {}
  teable-data: {}
  teable-cache: {}
```

```text .env
# Replace the default password below with a strong password (ASCII) of at least 8 characters.
POSTGRES_PASSWORD=postgres
REDIS_PASSWORD=redis123
SECRET_KEY=lijingwei9060

# Replace the following with a publicly accessible address
PUBLIC_ORIGIN=http://10.203.162.28:3000

# ---------------------

# Postgres
POSTGRES_HOST=teable-db
POSTGRES_PORT=5432
POSTGRES_DB=teable
POSTGRES_USER=teable

# Redis
REDIS_HOST=teable-cache
REDIS_PORT=6379
REDIS_DB=0

# App
PRISMA_DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}
BACKEND_CACHE_PROVIDER=redis
BACKEND_CACHE_REDIS_URI=redis://default:${REDIS_PASSWORD}@${REDIS_HOST}:${REDIS_PORT}/${REDIS_DB}
```