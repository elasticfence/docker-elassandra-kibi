#!/bin/bash
set -e
# set -xv

echo "Starting Elassandra... "
export CASSANDRA_HOME=/opt/elassandra
source $CASSANDRA_HOME/bin/aliases.sh
$CASSANDRA_HOME/bin/cassandra -e &
sleep 5

# Patch demo kibi to use standard ES port
perl -p -i -e "s/localhost:9200/127.0.0.1:9200/" /opt/kibana/config/kibana.yml
perl -p -i -e "s/localhost/172.17.0.2/" /opt/kibana/config/kibana.yml

# Start kibana
echo "Starting Kibana... "
/opt/kibana/bin/kibana >> $CASSANDRA_LOGS/kibana.log &

# Get Cassandra Status
$CASSANDRA_HOME/bin/nodetool status &

tail -f $CASSANDRA_LOGS/system.log
