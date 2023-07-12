FROM ubuntu:latest
LABEL authors="Socheata"

ENTRYPOINT ["top", "-b"]

#
# Build stage
#
FROM gradle:7.0.2-jdk17 AS build
WORKDIR /app
COPY . /app/
RUN ./gradlew clean build

#
# Package stage
#
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
