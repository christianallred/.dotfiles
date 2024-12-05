docker network create wolverine

docker build . -f docker/stripe/Dockerfile -t tavahealth/stripe-mock

docker run --rm --name stripe -p 8420:8420 \
      --network wolverine --network-alias stripe \
      -d tavahealth/stripe-mock;

docker run --rm --name postgres -p 5432:5432 \
      --network wolverine --network-alias postgres \
      -e POSTGRES_DB=postgres \
      -e POSTGRES_USER=postgres \
      -e POSTGRES_PASSWORD=admin \
      --health-cmd pg_isready \
      --health-interval 10s \
      --health-timeout 5s \
      --health-retries 5 \
      -d postgis/postgis:14-3.4-alpine;

docker run --rm --name postgrest -p 3010:3000 \
      --network wolverine --network-alias postgrest \
      -e PGRST_DB_URI=postgres://postgres:admin@postgres:5432/postgres \
      -e PGRST_DB_SCHEMA=public \
      -e PGRST_DB_ANON_ROLE=postgres \
      -d postgrest/postgrest:v11.2.1
