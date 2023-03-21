#!/bin/bash
function installRepAgents {
      echo "Waiting 2 minutes to ensure initial AEM startup has completed..."
      for i in {120..0}; do sleep 1; done; echo
      echo "Updating replication agents to ensure they can communicate via the internal docker network."
      curl -u admin:admin -F file=@"aem-base/packages/author-replication-agents.zip" -F name="author-replication-agents" -F force=true -F install=true http://localhost:4502/crx/packmgr/service.jsp
      curl -u admin:admin -F file=@"aem-base/packages/publish-replication-agents.zip" -F name="publish-replication-agents" -F force=true -F install=true http://localhost:4503/crx/packmgr/service.jsp
}

function resetAEMContainers {
     echo "Please confirm you wish to remove the current AEM containers and rebuild them.\nThis will remove any custom code or content in your local AEM servers.\nEnter 1 or 2:"
     select yn in "Yes" "No"; do
     case $yn in
        Yes ) 
            echo "Resetting the AEM author and publisher."
            authorContainer=$(docker ps -aqf "name=^aem-devkit-author-1$")
            publishContainer=$(docker ps -aqf "name=^aem-devkit-publish-1$")
            dispatcherContainer=$(docker ps -aqf "name=^aem-devkit-dispatcher-1$")
            aemBaseImage=$(docker images -q aem-base:latest)
            aemDispatcherImage=$(docker images -q aem-dispatcher:latest)

            #Stop and remove the AEM containers
            if [ "$( docker container inspect -f '{{.State.Status}}' $authorContainer )" == "running" ]; then
                  docker container stop ${authorContainer}
                  sleep 5
            fi
            docker container rm ${authorContainer}

            if [ "$( docker container inspect -f '{{.State.Status}}' $publishContainer )" == "running" ]; then
                  docker container stop ${publishContainer}
                  sleep 5
            fi
            docker container rm ${publishContainer}

            if [ "$( docker container inspect -f '{{.State.Status}}' $dispatcherContainer )" == "running" ]; then
                  docker container stop ${dispatcherContainer}
                  sleep 5
            fi
            docker container rm ${dispatcherContainer}

            echo "Existing AEM containers removed."

            #Remove the AEM images
            docker image rm ${aemBaseImage}
            docker image rm ${aemDispatcherImage}

            echo "AEM Docker images removed."

            #Remove the volumes
            docker volume rm aem-devkit_authordata
            docker volume rm aem-devkit_publishdata

            echo "AEM Docker volumes removed."

            #Remove the network stack
            docker network rm aem-devkit_aem-devkit
            
            echo "AEM Docker network removed."

            break;;

         No )
            echo "Reset aborted."
            break;;
      esac
      done
}

function start { 
      #If the aem-base image doesn't exist locally, build the author and publisher.
      if [[ "$(docker images -q aem-base:latest 2> /dev/null)" == "" ]]; then 
            echo "The author and publisher images don't exist locally, building them now."
            docker build --no-cache --tag aem-base:latest aem-base
            #Start the AEM docker images.
            echo "Starting the author and publisher for the first time."
            echo "As this is the first time start-up, it will take several minutes."
            docker-compose up -d author
            docker-compose up -d publish
            #Use the initial startup delay timing if provided, or default to 30 minutes
            if [[ $# -gt 0 && ${1} =~ ^[(0-9)]+$ ]]; then
                  initStart=${1}
                  initStartWait=$((${1} * 60))
            else
                  initStart=30
                  initStartWait=1800
            fi
            echo "Allow ${initStart} minutes for fix packs to be installed and AEM updated."
            for (( i=${initStartWait}; i>=0; i-- )); do sleep 1; done; echo
            echo "Restarting author and publisher. This is normal for first time setup."
            docker stop aem-devkit-author-1  
            docker stop aem-devkit-publish-1
            sleep 120
            docker start aem-devkit-author-1
            docker start aem-devkit-publish-1
            #Install the replication agents.
            installRepAgents
      else
            #Start the AEM docker images.
            docker-compose up -d author
            docker-compose up -d publish
      fi

      #If the aem-dispatcher image doesn't exist locally, clone the configs project and build the dispatcher.
      if [[ "$(docker images -q aem-dispatcher:latest 2> /dev/null)" == "" ]]; then 
            echo "The dispatcher image doesn't exist locally, building it now."
            docker build --tag aem-dispatcher:latest aem-dispatcher

            #Start the AEM dispatcher image.
            docker-compose up -d dispatcher
      else
            #Start the AEM dispatcher image.
            docker-compose up -d dispatcher      
      fi


      #Open the AEM author in the default browser.
      startAEM
      exit
}

function startAEM {
	#Opening AEM...
	echo "AEM start-up in progress..."
      sleep 120
	if [[ $OSTYPE = "darwin"* ]]; then
	    open http://localhost:4502
	else
	    #This assumes your Linux environment has xdg-open available.
	    xdg-open http://localhost:4502
	fi

      echo "AEM Started."
      sleep 5
}

#Check for reset arguments and act accordingly
if [[ $# -gt 1 && ${2} =~ ^[(resetaem)]+$ ]]; then
      resetAEMContainers "${1}" "${2}"
fi  

start "${1}" "${2}"
