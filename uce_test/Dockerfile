FROM anapsix/alpine-java:8_server-jre_unlimited
MAINTAINER kirk77@gmail.com

###################################################
# openfire
###################################################

ENV OPENFIRE_VERSION=4_0_3 \
    #DATA_DIR=/var/lib/data
	DATA_DIR=/c/Users/kirk/docker_data

RUN wget http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_${OPENFIRE_VERSION}.tar.gz -O /openfire_${OPENFIRE_VERSION}.tar.gz \
&& tar -xvzf /openfire_${OPENFIRE_VERSION}.tar.gz \
&& mv openfire /opt/openfire \
&& rm -f openfire_${OPENFIRE_VERSION}.tar.gz

RUN echo "/opt/openfire/bin/openfire start" >> /start.sh
EXPOSE 3478/tcp 3479/tcp 5222/tcp 5223/tcp 5229/tcp 7070/tcp 7443/tcp 7777/tcp 9090/tcp 9091/tcp


###################################################
# mariadb
###################################################
ENV MYSQL_ROOT_PASSWORD=root123

RUN set -ex && \
    apk add --no-cache bash mariadb mariadb-client tzdata && \
    mkdir -p /run/mysqld && \
    chown mysql:mysql /run/mysqld && \
    sed -Ei -e 's/^(bind-address|log)/#&/' \
        -e 's/^\[mysqld\]$/&\nskip-host-cache\nskip-name-resolve\nuser=mysql/' /etc/mysql/my.cnf
RUN mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

RUN echo "mysqld &" >> /start.sh
RUN echo "until (pidof mysqld)" >> /start.sh
RUN echo "	do" >> /start.sh
RUN echo "		sleep 1" >> /start.sh
RUN echo "	done" >> /start.sh

EXPOSE 3306/tcp

###################################################  
VOLUME ["${DATA_DIR}"]

RUN chmod 755 /start.sh
#RUN /start.sh

CMD ["bash"]
