
FROM tomcat:10.1-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY build/web/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080
