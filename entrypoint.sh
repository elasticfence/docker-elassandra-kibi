#!/bin/bash
set -e
set -xv

systemctl start elassandra
sleep 5

# Patch demo kibi to use standard ES port
perl -p -i -e "s/9220/9200/" /opt/kibi/config/kibi.yml
perl -p -i -e "s/localhost/0.0.0.0/" /opt/kibi/config/kibi.yml

# Start Kibi
/etc/init.d/kibi start
tail -f /var/log/elasticsearch/*.log
