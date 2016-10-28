#Dockerfile
FROM oss17888/centos6.4
MAINTAINER kirk <kirk77@gmail.com>

RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y openssh-server
RUN yum install -y unzip
RUN yum install -y nc
RUN yum install -y vim-enhanced
RUN yum clean all -y

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh

#change root password
RUN echo 'root:root123' | chpasswd

#RUN curl https://git.oschina.net/feedao/Docker_shell/raw/start/ali-centos.sh | sh
#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8

EXPOSE 22
CMD /usr/sbin/sshd -D
#End
