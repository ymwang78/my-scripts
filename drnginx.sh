#!/bin/bash
if [ "$#" -eq 2 ]; then
    sudo docker run --name $1 -v /opt/docker/$1:/zdata -p $2 --net ffoverlay -d nginx
fi
if [ "$#" -eq 3 ]; then
    sudo docker run --name $1 -v /opt/docker/$1:/zdata -p $2 -p $3 --net ffoverlay -d nginx
fi
if [ "$#" -eq 4 ]; then
    sudo docker run --name $1 -v /opt/docker/$1:/zdata -p $2 -p $3 -p $4 --net ffoverlay -d nginx
fi
