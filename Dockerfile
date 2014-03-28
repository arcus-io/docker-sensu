FROM ubuntu:precise
MAINTAINER Arcus "http://arcus.io"

RUN wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
RUN echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
RUN apt-get update
RUN RUNLEVEL=1 DEBIAN_FRONTEND=noninteractive apt-get install -y sensu ca-certificates rabbitmq-server redis-server supervisor git-core

RUN /opt/sensu/embedded/bin/gem install redphone --no-rdoc --no-ri
RUN /opt/sensu/embedded/bin/gem install mail --no-rdoc --no-ri

RUN rm -rf /etc/sensu/plugins
RUN git clone https://github.com/sensu/sensu-community-plugins.git /tmp/sensu_plugins

RUN cp -Rpf /tmp/sensu_plugins/plugins /etc/sensu/
RUN find /etc/sensu/plugins/ -name *.rb -exec chmod +x {} \;

ADD supervisor.conf /etc/supervisor/conf.d/sensu.conf
ADD run.sh /tmp/sensu-install.sh

VOLUME /etc/sensu
VOLUME /var/log/sensu

EXPOSE 4567
EXPOSE 5672
EXPOSE 6379
EXPOSE 8080

CMD ["/tmp/sensu-install.sh"]