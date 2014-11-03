FROM mriedmann/baseimage-java7:0.0.1
MAINTAINER Michael Riedmann <michael_riedmann@live.com>

# Startup
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

# Basic Ubuntu-Env
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

# Install Basics
RUN apt-get install wget -y

# Download version 1.4.2 of logstash
RUN cd /tmp && \
    wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz && \
    tar -xzvf ./logstash-1.4.2.tar.gz && \
    mv ./logstash-1.4.2 /opt/logstash && \
    rm ./logstash-1.4.2.tar.gz

# Install contrib plugins
RUN /opt/logstash/bin/plugin install contrib
 
# Add Config
ADD logstash.conf /etc/logstash.conf
 
# Add service script
RUN mkdir /etc/service/logstash
ADD logstash-run.sh /etc/service/logstash/run

# Env
RUN mkdir /var/sincedb
ENV SINCEDB_DIR /var/sincedb

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Volumes
VOLUME ["/var/sincedb"]

# Expose Ports: Elasticsearch HTTP, ES transport, Kibana, Syslog
EXPOSE 9200 9300 9292 514