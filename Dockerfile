

FROM tomcat:10.1-jdk21-temurin

RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN ant clean dist

RUN cp dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
