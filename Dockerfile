FROM ubuntu:latest
LABEL authors="Socheata"

ENTRYPOINT ["top", "-b"]
#
# Build stage
#
FROM gradle:jdk17 AS build
WORKDIR /spring-apiUser
COPY . /spring-apiUser/

RUN gradle clean



#
# Package stage
#
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=build /spring-apiUser/build/libs/*.jar /spring-apiUser/app.jar
EXPOSE 5432
ENTRYPOINT ["java", "-jar", "app.jar"]

