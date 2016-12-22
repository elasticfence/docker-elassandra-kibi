#!/bin/bash
set -e
set -xv

# Prerun
swapoff -a

echo "Starting Elassandra... "
export CASSANDRA_HOME=/opt/elassandra
source $CASSANDRA_HOME/bin/aliases.sh
$CASSANDRA_HOME/bin/cassandra -e &
sleep 5

# Patch demo kibi to use standard ES port
perl -p -i -e "s/9220/9200/" /opt/kibi/config/kibi.yml
perl -p -i -e "s/localhost/172.17.0.2/" /opt/kibi/config/kibi.yml

# Start Kibi
echo "Starting Kibi... "
/opt/kibi/bin/kibi >> $CASSANDRA_LOGS/kibi.log &

# Get Cassandra Status
$CASSANDRA_HOME/bin/nodetool status &
# Get ES Status
status

tail -f $CASSANDRA_LOGS/system.log
