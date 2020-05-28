FROM centos:7

COPY apache-maven-3.1.1-bin.tar.gz /
COPY node-v12.16.3-linux-x64.tar /
COPY hue-4.7.0.tgz /

ENV MAVEN_HOME /apache-maven-3.1.1
ENV NODE_HOME /nodejs
ENV PATH $MAVEN_HOME/bin:$NODE_HOME/bin:$PATH

RUN cd / && \
    yum update -y && \
    yum install -y wget vim ant asciidoc cyrus-sasl-devel \
    cyrus-sasl-gssapi cyrus-sasl-plain gcc gcc-c++ \
    krb5-devel libffi-devel libxml2-devel libxslt-devel \
    make  mysql mysql-devel openldap-devel python-devel \
    sqlite-devel gmp-devel libffi  gcc gcc-c++ kernel-devel \
    openssl-devel gmp-devel openldap-devel && \
    tar -xzf apache-maven-3.1.1-bin.tar.gz && \
    tar -xvf node-v12.16.3-linux-x64.tar && \
    mv node-v12.16.3-linux-x64 nodejs && \
    useradd hdfs && \
    mv hue-4.7.0.tgz /home/hdfs/ &&\
    cd /home/hdfs && \
    tar -xzf hue-4.7.0.tgz

COPY node_modules /home/hdfs/hue-4.7.0/node_modules

RUN cd /home/hdfs/hue-4.7.0 && \
    make apps && \
    cd .. && chown -R hdfs:hdfs hue-4.7.0

WORKDIR /home/hdfs/hue-4.7.0
USER hdfs

CMD build/env/bin/supervisor
