#!/usr/bin/env sh

curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/gyzpunk/readthedocs/trigger/${DOCKER_TOKEN}/
