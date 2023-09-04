#!/bin/bash

#docker stop $(docker ps -aq)
docker container stop $(docker ps --format '{{.ID}}' -f name=prometheus) > /dev/null 2>&1
docker container stop $(docker ps --format '{{.ID}}' -f name=grafana) > /dev/null 2>&1
#docker container stop $(docker ps --format '{{.ID}}' -f name=node-exporter) > /dev/null 2>&1
#docker container stop $(docker ps --format '{{.ID}}' -f name=nginx-exporter) > /dev/null 2>&1
#docker container stop $(docker ps --format '{{.ID}}' -f name=postgres-exporter) > /dev/null 2>&1
#docker container stop $(docker ps --format '{{.ID}}' -f name=prometheus) > /dev/null 2>&1
#docker container stop $(docker ps --format '{{.ID}}' -f name=grafana) > /dev/null 2>&1
#docker container stop $(docker ps --format '{{.ID}}' -f name=influxdb) > /dev/null 2>&1
#docker container stop $(docker ps --format '{{.ID}}' -f name=advisor-exporter) > /dev/null 2>&1

#for container_id in $(docker ps --format '{{.ID}}' -f name=prometheus); do
#    docker container rm $container_id
#done
#docker container rm $(docker ps --format "{{.ID}}" -f name=prometheus) #> /dev/null 2>&1
#docker container rm $(docker ps --format "{{.ID}}" -f name=grafana) #> /dev/null 2>&1
#docker container rm $(docker ps --format '{{.ID}}' -f name=node-exporter) > /dev/null 2>&1
#docker container rm $(docker ps --format '{{.ID}}' -f name=nginx_exporter) > /dev/null 2>&1
#docker container rm $(docker ps --format '{{.ID}}' -f name=postgres_exporter) > /dev/null 2>&1

docker rm $(docker ps --filter status=exited -q)
#docker rm $(docker ps -a | grep Exited | awk '{print $1}')

