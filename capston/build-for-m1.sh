#! /bin/bash
mvn clean package
docker build -t stock/configserver:0.0.1-SNAPSHOT --build-arg JAR_FILE=target/configserver-0.0.1-SNAPSHOT.jar ./configserver
docker build -t stock/eurekaserver:0.0.1-SNAPSHOT --build-arg JAR_FILE=target/eurekaserver-0.0.1-SNAPSHOT.jar ./eurekaserver
docker build -t stock/scrape:0.0.1-SNAPSHOT --build-arg JAR_FILE=target/scrape-0.0.1-SNAPSHOT.jar ./scrape