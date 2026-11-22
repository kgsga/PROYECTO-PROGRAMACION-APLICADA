
FROM tomcat:10.1-jdk21-temurin

RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN ant \
    -Dj2ee.server.home=/usr/local/tomcat \
    -Dlibs.CopyLibs.classpath=/app/lib/org-netbeans-modules-java-j2seproject-copylibstask.jar \
    clean dist

RUN rm -rf /usr/local/tomcat/webapps/ROOT

RUN cp dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

