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
# tomcat
###################################################
ENV TOMCAT_MAJOR=7 \
	TOMCAT_VERSION=7.0.73 \
	TOMCAT_HOME=/opt/tomcat \
	CATALINA_HOME=/opt/tomcat \
	CATALINA_OUT=/dev/null
	
RUN curl -jksSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
	gunzip /tmp/apache-tomcat.tar.gz && \
    tar -C /opt -xf /tmp/apache-tomcat.tar && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
    rm -rf ${TOMCAT_HOME}/webapps/docs ${TOMCAT_HOME}/webapps/examples ${TOMCAT_HOME}/webapps/host-manager ${TOMCAT_HOME}/webapps/ROOT && \
    apk del curl glibc-i18n
	
###################################################
# mysql
###################################################
ENV DATA_DIR=/c/Users/kirk/docker_data \
	MYSQL_ROOT_PASSWORD=root123 \
	MYSQL_DATABASE=kirk \
	MYSQL_USER=kirk \
	MYSQL_PASSWORD=kirk123
	
RUN apk add --update mysql && \
    mkdir -p /var/lib/mysql && \
    mkdir -p /etc/mysql/conf.d && \
    { \
        echo '[mysqld]'; \
        echo 'user = root'; \
        echo 'datadir = /var/lib/mysql'; \
        echo 'port = 3306'; \
        echo 'log-bin = /var/lib/mysql/mysql-bin'; \
        echo 'socket = /var/lib/mysql/mysql.sock'; \
        echo '!includedir /etc/mysql/conf.d/'; \
    } > /etc/mysql/my.cnf
RUN	mysql_install_db --user=root > /dev/null
RUN	echo "USE mysql;" >> /tfile.sql && \
	echo "FLUSH PRIVILEGES;" >> /tfile.sql && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;" >> /tfile.sql && \
	echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;" >> /tfile.sql && \
	echo "UPDATE user SET password=PASSWORD('') WHERE user='root' AND host='localhost';" >> /tfile.sql && \
	echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> /tfile.sql && \
	echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> /tfile.sql && \
	echo "FLUSH PRIVILEGES;" >> /tfile.sql

RUN	/usr/bin/mysqld --user=root --bootstrap --verbose=0 < /tfile.sql && \
	rm -rf /tmp/* /var/cache/apk/* /tfile.sql /opt/tomcat/conf/tomcat-users.xml && \
	echo "<?xml version='1.0' encoding='utf-8'?>" >> /opt/tomcat/conf/tomcat-users.xml && \
	echo "<tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml && \
	echo "<role rolename='manager-gui'/>" >> /opt/tomcat/conf/tomcat-users.xml && \
	echo "<role rolename='manager-script'/>" >> /opt/tomcat/conf/tomcat-users.xml && \
	echo "<user username='kirk' password='kirk2017' roles='manager-gui,manager-script'/>" >> /opt/tomcat/conf/tomcat-users.xml && \
	echo "</tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml
	
RUN echo "mysqld &" >> /start.sh && \
    echo "until (pidof mysqld)" >> /start.sh && \
    echo "	do" >> /start.sh && \
    echo "		sleep 1" >> /start.sh && \
    echo "	done" >> /start.sh && \
	echo "/opt/tomcat/bin/startup.sh" >> /start.sh

EXPOSE 3306/tcp
###################################################  

VOLUME ["${DATA_DIR}"]

RUN chmod 755 /start.sh
CMD ["/start.sh && bash"]
