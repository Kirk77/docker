FROM anapsix/alpine-java:8_server-jre_unlimited
MAINTAINER kirk77@gmail.com

ENV OPENFIRE_VERSION=4_0_3 \
    OPENFIRE_DATA_DIR=/var/lib/openfire

RUN wget http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_${OPENFIRE_VERSION}.tar.gz -O /openfire_${OPENFIRE_VERSION}.tar.gz \
&& tar -xvzf /openfire_${OPENFIRE_VERSION}.tar.gz \
&& mv openfire /opt/openfire

EXPOSE 3478/tcp 3479/tcp 5222/tcp 5223/tcp 5229/tcp 7070/tcp 7443/tcp 7777/tcp 9090/tcp 9091/tcp

VOLUME ["${OPENFIRE_DATA_DIR}"]
CMD ["bash"]
