#!/bin/bash
set -e
set -xv

systemctl start elassandra

tail -f /var/log/syslog
