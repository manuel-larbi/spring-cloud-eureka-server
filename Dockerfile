FROM maven:3-openjdk-17-slim AS package

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn dependency:go-offline && mvn clean install


FROM openjdk:17-slim AS run

WORKDIR /app

ENV APPLICATION_NAME=eureka-server \
    SERVER_PORT=8761 \
    SERVER_HOSTNAME=localhost

COPY --from=package /app/target/eureka-server-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "app.jar"]