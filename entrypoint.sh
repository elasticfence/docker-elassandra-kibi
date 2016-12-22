#!/bin/bash
set -e
set -xv

# Prerun
swapoff -a

echo "Starting Elassandra... "
export CASSANDRA_HOME=/opt/elassandra
source $CASSANDRA_HOME/bin/aliases.sh
$CASSANDRA_HOME/bin/cassandra -e > /var/log/elassandra.log &
sleep 10
$CASSANDRA_HOME/bin/nodetool status

# Patch demo kibi to use standard ES port
perl -p -i -e "s/9220/9200/" /opt/kibi/config/kibi.yml
perl -p -i -e "s/localhost/172.17.0.2/" /opt/kibi/config/kibi.yml

# Start Kibi
echo "Starting Kibi... "
/opt/kibi/bin/kibi >> /opt/elassandra/logs/kibi.log &

tail -f /var/log/elassandra.log
