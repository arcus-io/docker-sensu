FROM ubuntu:12.04
MAINTAINER Arcus "http://arcus.io"
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget
RUN wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
RUN echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
RUN apt-get update
RUN RUNLEVEL=1 DEBIAN_FRONTEND=noninteractive apt-get install -y sensu ca-certificates rabbitmq-server redis-server supervisor git-core
RUN git clone https://github.com/sensu/sensu-community-plugins.git /opt/sensu_plugins

RUN ln -s /opt/sensu/embedded/bin/ruby /usr/local/bin/ruby
RUN ln -s /opt/sensu/embedded/bin/gem /usr/local/bin/gem

RUN gem install redphone --no-rdoc --no-ri
RUN gem install mail --no-rdoc --no-ri

RUN rm -rf /etc/sensu/plugins
RUN ln -sf /opt/sensu_plugins/plugins /etc/sensu/plugins
RUN find /etc/sensu/plugins/ -name *.rb | xargs chmod +x

ADD supervisor.conf /etc/supervisor/conf.d/sensu.conf
ADD run.sh /usr/local/bin/run

VOLUME /etc/sensu
VOLUME /var/log/sensu

EXPOSE 4567
EXPOSE 5672
EXPOSE 6379
EXPOSE 8080
CMD ["/usr/local/bin/run"]
