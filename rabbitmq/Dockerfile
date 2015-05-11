FROM rabbitmq:3-management

MAINTAINER Borja Berastegui <@BBerastegui>

# Add scripts
ADD run.sh /run.sh
RUN chmod 755 ./*.sh

ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config

ADD ./CA ~/rmq_CA

EXPOSE 5672
EXPOSE 15672
