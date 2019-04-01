#!/bin/sh

rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

rpm -ivh https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm

yum install postgresql11-libs boost hiredis gperftools-libs mariadb-libs

yum install telnet vim less gdb net-tools git lrzsz wget;

