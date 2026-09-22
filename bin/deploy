#!/bin/bash -e
# Deploy the latest code to this docker-compose host.
# Run this ON THE SERVER, from the app checkout directory.
#
# Only recreates the `web` service -- database/redis are left alone since
# their config rarely changes. `bin/rails db:prepare` runs automatically on
# every web container start (see docker-compose.yml's command), so no
# separate migration step is needed here.
#
# Uses stop + rm + up instead of `--force-recreate`, which on some
# docker-compose versions triggers a ContainerConfig bug that also touches
# unrelated services (database/redis) and fails.

echo "==> Pulling latest code"
git pull

echo "==> Recreating web container"
docker-compose stop web
docker-compose rm -f web
docker-compose up -d --build web

echo "==> Recent web logs"
docker-compose logs --tail 30 web

echo "==> Done. Container status:"
docker-compose ps
