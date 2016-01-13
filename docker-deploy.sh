#!/usr/bin/env sh

curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/gyzpunk/readthedocs/trigger/274048bd-f547-4dfb-aaef-939c36382a09/
