# Introduction 
This is the AEM developer toolkit. This provides a portable/self-contained development environment for AEM projects, which includes a containerized AEM author, publisher and dispatcher, running on JDK 11 64bit.



# Getting Started
You will need docker (https://www.docker.com/get-started) installed on your system to use this kit.
Clone this repo to your local system.



# Github Specifics

Due to Github's file size limitations, you will need to obtain the 6.5.14 service pack from here: https://experience.adobe.com/#/downloads/content/software-distribution/en/aem.html?package=%2Fcontent%2Fsoftware-distribution%2Fen%2Fdetails.html%2Fcontent%2Fdam%2Faem%2Fpublic%2Fadobe%2Fpackages%2Fcq650%2Fservicepack%2Faem-service-pkg-6.5.14.0.zip

You also need to obtain the AEM 6.5 jar file. Rename the jar file as "cq-quickstart-6.5.0.jar", then place this jar file and the service pack in the aem-base/packages folder. You should only need to do this once, even if using the resetaem option.



# Standing up the Environment

Running the "Start-All.sh" script in the root/top level of this repository will start an AEM Author (listening on port 4502), an AEM Publisher (listening on port 4503), a Dispatcher and open your default browser to http://localhost:4502.

("Stop-AEM.sh" will stop the running AEM instances.)



# Cloning Optimally 

To reduce the time it takes git to retrieve this repo by as much as possible, you can clone the project using this command:
git clone --depth 1 -b master --single-branch https://github.com/PRFTAdobe/aem-devkit



# Resetting your local AEM environment

If you would like to clean out your local AEM setup and start over, run the Start-All.sh script with the "resetaem" argument: (sh Start-All.sh 30 resetaem).
This will remove the existing docker containers, base images and volumes, forcing them to be re-created.
