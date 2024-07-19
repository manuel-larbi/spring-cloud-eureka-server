FROM openjdk:17-slim

WORKDIR /app

COPY target/eureka-server-0.0.1-SNAPSHOT.jar app.jar
COPY src/main/resources/.env .env

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "app.jar"]