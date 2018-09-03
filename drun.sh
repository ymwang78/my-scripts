#!/bin/bash
sudo docker run --name $1 --privileged -ti -e container=docker  -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /opt/docker/$1:/zdata -p $3 -p $4 --net doverlay $2 /usr/sbin/init
