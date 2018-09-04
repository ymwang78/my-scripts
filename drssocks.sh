#!/bin/bash
docker run -d -p $2:1984 --net ffoverlay --name $1 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k $3 -m aes-256-cfb
