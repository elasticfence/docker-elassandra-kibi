#!/bin/bash
set -e
set -xv

# Prerun
swapoff -a

# Patch demo kibi to use standard ES port
perl -p -i -e "s/9220/9200/" /opt/kibi/config/kibi.yml
perl -p -i -e "s/localhost/172.17.0.2/" /opt/kibi/config/kibi.yml

# Start Kibi
/opt/kibi/bin/kibi >> /opt/elassandra/logs/kibi.log &

# Start Elassandra
/opt/elassandra/bin/elassandra start

tail -f /opt/elassandra/logs/*
