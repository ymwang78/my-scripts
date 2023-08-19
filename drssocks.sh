#!/bin/bash
#ssocker outport username password
sudo docker run -d -p $1:1984 --name $2 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k $3 -m aes-256-cfb
