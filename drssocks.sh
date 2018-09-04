#!/bin/bash
docker run -d -p $1:1984 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k $2 -m aes-256-cfb
