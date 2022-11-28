ARG AEM_RUNMODE=dev,author,local
FROM ubuntu:latest
ARG AEM_RUNMODE
ENV AEM_RUNMODE ${AEM_RUNMODE}

# Install JDK 11
RUN apt-get update
RUN apt-get install openjdk-11-jdk-headless -y

# Copy AEM Dependencies
ADD packages/license.properties packages/cq-quickstart-6.5.0.jar /data/aem/
RUN mkdir -p /data/aem/crx-quickstart/install
ADD packages/aem-service-pkg-6.5.14.0.zip \
    packages/author-replication-agents.zip \
    packages/publish-replication-agents.zip \
    packages/local-dam-mapping.zip \
    /data/aem/crx-quickstart/install/

# Setup AEM
EXPOSE 4502 30303 9999
WORKDIR /data/aem

ADD entrypoint.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]