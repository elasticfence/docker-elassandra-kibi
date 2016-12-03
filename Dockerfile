FROM debian:latest

# Maintainer
MAINTAINER lmangani <lorenzo.mangani@gmail.com>

# Setup
RUN cat << _EOF_ > /etc/apt/sources.list.d/testing.list \
 deb     http://mirror.steadfast.net/debian/ testing main contrib non-free \
 deb     http://ftp.us.debian.org/debian/    testing main contrib non-free \
 _EOF_ \
 && cat << _EOF_ > /etc/apt/sources.list.d/elassandra.list \
 deb http://packages.elassandra.io/deb/ ./ \
 _EOF_ \
 && wget -O- -q http://packages.elassandra.io/pub/GPG-KEY-Elassandra > /tmp/GPG-KEY-Elassandra \
 && apt-key add  /tmp/GPG-KEY-Elassandra \
 # Setup pip packages
 && apt-get -y install python-pip python-cassandra wget curl libjemalloc1 \
 && pip install --upgrade pip \
 && pip install --upgrade cassandra-driver \
 && pip install cqlsh \
 ## Install Java
 && apt-get -y install oracle-java8-jre \
 && update-alternatives --auto java \
 ## Install JNA
 && sudo apt-get -y install libjna-java \
 && ln -s /usr/share/java/jna.jar install_location/lib \
 ## Install Elassandra 
 && apt-get clean && apt-get -y install elassandra \
 ## Setup Extras
 && groupadd -r kibi && useradd -r -m -g kibi kibi \
 && apt-get update && apt-get clean \
 && wget -O /dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 \
 && chmod +x /dumb-init \
 && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
 && apt-get install -y nodejs \
 ## Get Kibi
 && cd /opt && wget https://download.support.siren.solutions/kibi/community?file=kibi-community-standalone-4.5.4-linux-x64.zip -O kibi-4.5.4-linux-x64.zip \
 && unzip kibi-4.5.4-linux-x64.zip \
 && rm -rf /opt/kibi-4.5.4-linux-x64.zip \
 && mv kibi-community-standalone-4.5.4-linux-x64 kibi \
 && chown -R kibi:kibi /opt/kibi \
 ## Stuff
 && cd /opt/kibi \
 && ./bin/kibi plugin --install sentinl -u https://github.com/sirensolutions/sentinl/releases/download/snapshot/sentinl-latest.tar.gz \
 # && ./bin/kibi plugin --install kibana-auth-plugin -u https://github.com/elasticfence/kibana-auth-elasticfence/releases/download/snapshot/kauth-latest.tar.gz \
 && ./bin/kibi plugin --install kibrand -u https://github.com/elasticfence/kibrand/archive/0.4.5.zip \
 && ./bin/kibi plugin --install elastic/timelion \
 && ./bin/kibi plugin --install elastic/sense \
 && chown -R kibi:kibi /opt/kibi \
 ## Cleanup
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh

EXPOSE 7000/tcp 7001/tcp 7199/tcp 9042/tcp 9160/tcp 9200/tcp 5601/tcp

ENTRYPOINT ["/opt/entrypoint.sh"]



