#!/bin/bash

echo "################# USER DATA #################"

echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config

cat /etc/ecs/ecs.config
service docker restart && start ecs
service docker status
docker container list