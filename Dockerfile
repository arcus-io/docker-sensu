FROM ubuntu:12.04
MAINTAINER Arcus "http://arcus.io"
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget
RUN wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
RUN echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
RUN apt-get update
RUN RUNLEVEL=1 DEBIAN_FRONTEND=noninteractive apt-get install -y sensu ca-certificates rabbitmq-server redis-server supervisor ruby rubygems git-core
RUN git clone https://github.com/sensu/sensu-community-plugins.git /opt/sensu_plugins

RUN /opt/sensu/embedded/bin/gem install sensu-plugin --no-rdoc --no-ri
RUN /opt/sensu/embedded/bin/gem install net-ping --no-rdoc --no-ri
RUN /opt/sensu/embedded/bin/gem install redphone --no-rdoc --no-ri

RUN rm -rf /etc/sensu/plugins
RUN ln -sf /opt/sensu_plugins/plugins/ /etc/sensu/plugins
RUN chmod +x /etc/sensu/plugins/*

ADD supervisor.conf /opt/supervisor.conf
ADD run.sh /usr/local/bin/run

VOLUME /etc/sensu
VOLUME /var/log/sensu

EXPOSE 4567
EXPOSE 5672
EXPOSE 6379
EXPOSE 8080
CMD ["/usr/local/bin/run"]
