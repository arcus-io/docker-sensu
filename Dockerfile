FROM ubuntu:12.04
MAINTAINER Arcus "http://arcus.io"
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget
RUN wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
RUN echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sensu rabbitmq-server redis-server supervisor openssh-server ruby rubygems
RUN wget -O /etc/sensu/plugins/check-procs.rb https://raw.github.com/sensu/sensu-community-plugins/master/plugins/processes/check-procs.rb
RUN chmod 755 /etc/sensu/plugins/check-procs.rb
RUN gem install sensu-plugin --no-rdoc --no-ri

RUN mkdir /root/.ssh
RUN mkdir /var/run/sshd
# NOTE: change this key to your own
ADD sshkey.pub /root/.ssh/authorized_keys
ADD config.json /etc/sensu/config.json
ADD client.json /etc/sensu/conf.d/client.json
ADD supervisor.conf /opt/supervisor.conf
RUN chown root:root /root/.ssh/authorized_keys
ADD run.sh /usr/local/bin/run

EXPOSE 22
EXPOSE 4567
EXPOSE 5672
EXPOSE 6379
EXPOSE 8080
CMD ["/usr/local/bin/run"]
