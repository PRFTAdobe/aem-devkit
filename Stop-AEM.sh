#!/bin/bash
#This script stops the docker containers running AEM and the dispatcher.
docker stop $(docker ps -a -q --filter ancestor=aem-base --format="{{.ID}}")
docker stop $(docker ps -a -q --filter ancestor=aem-dispatcher --format="{{.ID}}")
exit