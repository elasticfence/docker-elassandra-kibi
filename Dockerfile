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
 && systemctl enable elassandra 

COPY entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh

EXPOSE 7000/tcp 7001/tcp 7199/tcp 9042/tcp 9160/tcp 9200/tcp 5601/tcp

ENTRYPOINT ["/opt/entrypoint.sh"]



