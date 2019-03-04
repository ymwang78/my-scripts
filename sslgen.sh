#!/bin/sh
openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -out ca.csr -subj "/C=US/ST=California/L=San Francisco/O=My Company, Inc./CN=CA/"
openssl x509 -req -in ca.csr -out ca.pem -signkey ca.key -days 3650

openssl genrsa -out server.key 2048
openssl req -new -out server.csr -key server.key -subj "/C=US/ST=California/L=San Francisco/O=My Company, Inc./CN=*.zua.com/"
openssl x509 -req -in server.csr -out server.pem -signkey server.key -CA ca.pem -CAkey ca.key -CAcreateserial -days 3650
openssl verify -CAfile ca.pem  server.pem

openssl genrsa -out client.key 2048
openssl req -new -out client.csr -key client.key -subj "/C=US/ST=California/L=San Francisco/O=My Company, Inc./CN=zuac/"
openssl x509 -req -in client.csr -out client.pem -signkey client.key -CA ca.pem -CAkey ca.key -CAcreateserial -days 3650
openssl verify -CAfile ca.pem client.pem
