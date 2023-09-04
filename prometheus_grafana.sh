#!/bin/bash

# Prometheus
if [ "$(docker ps -aq -f name=prometheus)" ]; then
    echo "Prometheus container already exists."
else
    docker run -d --restart=always -p 9090:9090 \
    --name prometheus \
    -v /var/lib/docker/volumes/prometheus/data:/var/lib/prometheus \
    --user "$(id -u):$(id -g)" \
    -v /opt/project/kanban-board/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
    --net="kanban-board_default" \
    prom/prometheus
fi

# grafana
if [ "$(docker ps -aq -f name=grafana)" ]; then
    echo "name grafana container already exists."
else
    docker run -d --restart=always -p 3000:3000 \
    --name grafana \
    -v /var/lib/docker/volumes/grafana/data:/var/lib/grafana \
    --user "$(id -u):$(id -g)" \
    --net="kanban-board_default" \
    grafana/grafana
#    -e GF_SECURITY_ADMIN_USER="admin" \
#    -e GF_SECURITY_ADMIN_PASSWORD="admin" \
#    -e GF_SERVER_ALLOW_ORIGIN="*" \

fi
# nginx_exporter
if [ "$(docker ps -aq -f name=nginx-exporter)" ]; then
    echo "nginx-exporter container already exists."
else
    docker run -d --restart=always -p 9113:9113 \
    --name nginx-exporter \
    --link my-nginx:nginx \
    --net="kanban-board_default" \
    nginx/nginx-prometheus-exporter:0.4.2 \
    -nginx.scrape-uri http://192.168.2.169:80/nginx_status -nginx.retries=10 \
    -web.telemetry-path=/metrics
fi
# node_exporter:
if [ "$(docker ps -aq -f name=node-exporter)" ]; then
    echo "node-exporter container already exists."
else
    docker run -d --restart=always -p 9100:9100 \
    --name node-exporter \
    --net="kanban-board_default" \
    quay.io/prometheus/node-exporter
fi
# postgres_exporter:
if [ "$(docker ps -aq -f name=postgres-exporter)" ]; then
    echo "postgres-exporter container already exists."
else
    docker run -d --restart=always -p 9187:9187 \
    --name postgres-exporter \
    --link kanban-postgres \
    --net="kanban-board_default" \
    -e "DATA_SOURCE_URI=192.168.2.169:5432/kanban?sslmode=disable" \
    -e "DATA_SOURCE_USER=kanban" \
    -e "DATA_SOURCE_PASS=kanban" \
    prometheuscommunity/postgres-exporter:v0.11.1
fi
# influxdb
if [ "$(docker ps -aq -f name=influxdb)" ]; then
    echo "influxdb container already exists."
else
    docker run -d --restart=always -p 8086:8086 \
    --name influxdb \
    --net="kanban-board_default" \
    -v /opt/project/kanban-board/opt/project/kanban-board/influxdb/config.yml:/etc/influxdb2/config.yml \
    -v /var/lib/docker/volumes/influxdb:/var/lib/influxdb2 \
    --user "$(id -u):$(id -g)" \
    -e "INFLUXDB_DB=datainfluxdb" \
    -e "INFLUXDB_ADMIN_USER=admin" \
    -e "INFLUXDB_ADMIN_PASSWORD=admin123" \
    -e "org=neoflex" \
    -e "bucket=neoflex" \
    influxdb:2.0
fi
# advisor_exporter
if [ "$(docker ps -aq -f name=advisor-exporter)" ]; then
    echo "Advisor Exporter container already exists."
else
    docker run -d --restart=always -p 192.168.2.169:8085:8080 \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:rw \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --name advisor-exporter \
    --net="kanban-board_default" \
    google/cadvisor:v0.30.0
fi


#     prometheuscommunity/advisor-exporter:latest

#    -e INFLUXDB_DB=datainfluxdb \
#    -e INFLUXDB_ADMIN_USER=admin \
#    -e INFLUXDB_ADMIN_PASSWORD=admin123 \
#    -e org "neoflex" \
#    -e bucket="neoflex" \
#    -e force

#    image: prometheuscommunity/postgres-exporter:v0.10.1
#    restart: unless-stopped
#    deploy:
#      resources:
#        limits:
#          cpus: '0.2'
#          memory: 500M
#    networks:
#      - postgres


#--network kanban-board_default
# --network kanban_network

