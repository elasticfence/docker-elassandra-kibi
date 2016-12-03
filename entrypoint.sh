#!/bin/bash
set -e
set -xv

# Patch demo kibi to use standard ES port
perl -p -i -e "s/9220/9200/" /opt/kibi/config/kibi.yml
perl -p -i -e "s/localhost/0.0.0.0/" /opt/kibi/config/kibi.yml

# Start Kibi
/opt/kibi/bin/kibi >> /opt/elassandra/logs/kibi.log &

# Start Elassandra
/opt/elassandra/bin/elassandra start

tail -f /opt/elassandra/logs/*
