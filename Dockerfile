FROM ubuntu:latest
LABEL authors="Socheata"

ENTRYPOINT ["top", "-b"]
#
# Build stage
#
FROM gradle:jdk17 AS build
WORKDIR /app
COPY . /app/
RUN gradle --version
RUN gradle clean build


#
# Package stage
#
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/app.jar
EXPOSE 5432
ENTRYPOINT ["java", "-jar", "app.jar"]

