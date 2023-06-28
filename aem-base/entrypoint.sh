#!/usr/bin/env bash

java -Xmx3096M \
     -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:30303 \
     -Dcom.sun.management.jmxremote.port=9999 \
     -Dcom.sun.management.jmxremote.authenticate=false \
     -Dcom.sun.management.jmxremote.ssl=false \
     -jar cq-quickstart-6.5.0.jar \
     -nofork \
     -nobrowser \
     -r ${AEM_RUNMODE}