### Usage: mkdir -p /var/opt/jfrog/artifactory; export ARTIFACTORY_HOME=/var/opt/jfrog/artifactory; docker run -d --name artifactory-4.6.1 -p 80:80 -p 8081:8081 -p 443:443 -p 5000-5002:5000-5002 -v $ARTIFACTORY_HOME/data:$ARTIFACTORY_HOME/data -v $ARTIFACTORY_HOME/logs:$ARTIFACTORY_HOME/logs -v $ARTIFACTORY_HOME/backup:$ARTIFACTORY_HOME/backup -v $ARTIFACTORY_HOME/etc:$ARTIFACTORY_HOME/etc artifactory-docker-image:4.6.1


FROM tomcat:8.0.32-jre8

# To update, check https://bintray.com/jfrog/artifactory/jfrog-artifactory-oss-zip/view
ENV ARTIFACTORY_VERSION 4.6.1
ENV ARTIFACTORY_SHA1 59d5c15441f3dc3f885b336075a73e5033efb526

# Disable Tomcat's manager application.
RUN rm -rf webapps/*

# Redirect URL from / to artifactory/ using UrlRewriteFilter
COPY urlrewrite/WEB-INF/lib/urlrewritefilter.jar /
COPY urlrewrite/WEB-INF/urlrewrite.xml /
RUN \
  mkdir -p webapps/ROOT/WEB-INF/lib && \
  mv /urlrewritefilter.jar webapps/ROOT/WEB-INF/lib && \
  mv /urlrewrite.xml webapps/ROOT/WEB-INF/

# Fetch and install Artifactory OSS war archive.
RUN \
  echo $ARTIFACTORY_SHA1 artifactory.zip > artifactory.zip.sha1 && \
  curl -L -o artifactory.zip http://dl.bintray.com/content/jfrog/artifactory/jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip && \
  sha1sum -c artifactory.zip.sha1 && \
  unzip -j artifactory.zip "artifactory-*/webapps/artifactory.war" -d webapps && \
  rm artifactory.zip

# Expose tomcat runtime options through the RUNTIME_OPTS environment variable.
#   Example to set the JVM's max heap size to 256MB use the flag
#   '-e RUNTIME_OPTS="-Xmx256m"' when starting a container.
RUN echo 'export CATALINA_OPTS="$RUNTIME_OPTS"' > bin/setenv.sh

# Artifactory home
RUN mkdir -p /var/opt/jfrog/artifactory
ENV ARTIFACTORY_HOME /var/opt/jfrog/artifactory

#VOLUME $ARTIFACTORY_HOME/backup
#VOLUME $ARTIFACTORY_HOME/data
#VOLUME $ARTIFACTORY_HOME/logs
#VOLUME $ARTIFACTORY_HOME/etc

WORKDIR /var/opt/jfrog/artifactory

#EXPOSE 8080
