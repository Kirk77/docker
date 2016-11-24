FROM alpine:latest
MAINTAINER kirk77@gmail.com

###################################################
# java
###################################################
ENV JAVA_VERSION_MAJOR=7 \
    JAVA_VERSION_MINOR=80 \
	JAVA_VERSION_BUILD=15 \
	JAVA_PACKAGE=server-jre \
	JAVA_JCE=standard \
	JAVA_HOME=/opt/jdk \
	PATH=${PATH}:/opt/jdk/bin \
    GLIBC_VERSION=2.23-r3 \
    LANG=C.UTF-8

RUN apk upgrade --update && \
    apk add --update libstdc++ curl ca-certificates bash && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
	apk add --allow-untrusted /tmp/*.apk && \
	rm -v /tmp/*.apk && \
	( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
	echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
	/usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
	mkdir /opt && \
	curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/java.tar.gz \
	    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
	curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
        http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
		gunzip /tmp/java.tar.gz && \
	tar -C /opt -xf /tmp/java.tar && \
	ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
	find /opt/jdk/ -maxdepth 1 -mindepth 1 | grep -v jre | xargs rm -rf && \
	cd /opt/jdk/ && ln -s ./jre/bin ./bin && \
	if [ "${JAVA_JCE}" == "unlimited" ]; then echo "Installing Unlimited JCE policy" && \
	curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
    	http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
		cd /tmp && unzip /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
		cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar /opt/jdk/jre/lib/security/; \
	fi && \
	sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=30/ $JAVA_HOME/jre/lib/security/java.security && \
	apk del curl glibc-i18n && \
	rm -rf /opt/jdk/jre/plugin \
    	/opt/jdk/jre/bin/javaws \
		/opt/jdk/jre/bin/jjs \
		/opt/jdk/jre/bin/orbd \
		/opt/jdk/jre/bin/pack200 \
		/opt/jdk/jre/bin/policytool \
		/opt/jdk/jre/bin/rmid \
		/opt/jdk/jre/bin/rmiregistry \
		/opt/jdk/jre/bin/servertool \
		/opt/jdk/jre/bin/tnameserv \
		/opt/jdk/jre/bin/unpack200 \
		/opt/jdk/jre/lib/javaws.jar \
		/opt/jdk/jre/lib/deploy* \
		/opt/jdk/jre/lib/desktop \
		/opt/jdk/jre/lib/*javafx* \
		/opt/jdk/jre/lib/*jfx* \
		/opt/jdk/jre/lib/amd64/libdecora_sse.so \
		/opt/jdk/jre/lib/amd64/libprism_*.so \
		/opt/jdk/jre/lib/amd64/libfxplugins.so \
		/opt/jdk/jre/lib/amd64/libglass.so \
		/opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
		/opt/jdk/jre/lib/amd64/libjavafx*.so \
		/opt/jdk/jre/lib/amd64/libjfx*.so \
		/opt/jdk/jre/lib/ext/jfxrt.jar \
		/opt/jdk/jre/lib/ext/nashorn.jar \
		/opt/jdk/jre/lib/oblique-fonts \
		/opt/jdk/jre/lib/plugin.jar \
		/tmp/* /var/cache/apk/* && \
		echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf
	
###################################################
# openfire
###################################################

ENV OPENFIRE_VERSION=4_0_3 \
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

RUN echo "mysqld &" >> /start.sh && \
    echo "until (pidof mysqld)" >> /start.sh && \
    echo "	do" >> /start.sh && \
    echo "		sleep 1" >> /start.sh && \
    echo "	done" >> /start.sh

EXPOSE 3306/tcp

###################################################
# rabbitmq
###################################################
ENV RABBITMQ_VERSION=3.6.1
ENV RABBITMQ_HOME=/srv/rabbitmq_server-${RABBITMQ_VERSION} \
	PLUGINS_DIR=/srv/rabbitmq_server-${RABBITMQ_VERSION}/plugins \
	ENABLED_PLUGINS_FILE=/srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/enabled_plugins \
	RABBITMQ_MNESIA_BASE=/var/lib/rabbitmq
ENV PATH=$PATH:$RABBITMQ_HOME/sbin

COPY ssl.config /srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/
COPY standard.config /srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/
COPY wrapper.sh /usr/bin/wrapper

RUN echo "/usr/bin/wrapper " >> /start.sh

RUN chmod a+x /usr/bin/wrapper && apk add --update curl tar xz bash && \
	echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
	echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
	apk add erlang erlang erlang-mnesia erlang-public-key erlang-crypto erlang-ssl \
		erlang-sasl erlang-asn1 erlang-inets erlang-os-mon erlang-xmerl erlang-eldap \
		erlang-syntax-tools --update-cache --allow-untrusted
RUN	cd /srv && \
	rmq_zip_url=https://github.com/rabbitmq/rabbitmq-server/releases/download && \
	rmq_zip_url=${rmq_zip_url}/rabbitmq_v$(echo $RABBITMQ_VERSION | tr '.' '_') && \
	rmq_zip_url=${rmq_zip_url}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz && \
	curl -Lv -o /srv/rmq.tar.xz $rmq_zip_url && \
	tar -xvf rmq.tar.xz && rm -f rmq.tar.xz
RUN /usr/bin/wrapper
RUN	touch /srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/enabled_plugins
RUN	rabbitmq-plugins enable --offline rabbitmq_management && \
	rmq_ac_url=https://github.com/aweber/rabbitmq-autocluster/releases/download && \
	rmq_ac_url=${rmq_ac_url}/${RABBITMQ_AUTOCLUSTER_PLUGIN_VERSION} && \
	rmq_ac_url=${rmq_ac_url}/autocluster-${RABBITMQ_AUTOCLUSTER_PLUGIN_VERSION}.ez && \
	curl -Lv -o ${PLUGINS_DIR}/autocluster-${RABBITMQ_AUTOCLUSTER_PLUGIN_VERSION}.ez $rmq_ac_url && \
	apk del --purge tar xz && rm -Rf /var/cache/apk/* && \
	ln -sf $RABBITMQ_HOME /rabbitmq

EXPOSE	5671/tcp 5672/tcp 15672/tcp 15671/tcp

###################################################  
VOLUME ["${DATA_DIR}"]

RUN chmod 755 /start.sh
CMD ["/start.sh && bash"]
