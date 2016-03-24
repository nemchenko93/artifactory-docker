Usage:
mkdir -p /var/opt/jfrog/artifactory 
export ARTIFACTORY_HOME=/var/opt/jfrog/artifactory 
sudo docker run -d --name artifactory-4.6.1 -p 8082:8080 -v $ARTIFACTORY_HOME/data:$ARTIFACTORY_HOME/data -v $ARTIFACTORY_HOME/logs:$ARTIFACTORY_HOME/logs -v $ARTIFACTORY_HOME/backup:$ARTIFACTORY_HOME/backup -v $ARTIFACTORY_HOME/etc:$ARTIFACTORY_HOME/etc artifactory-docker-image:4.6.1
