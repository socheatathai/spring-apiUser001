FROM ubuntu:latest
LABEL authors="Socheata"

ENTRYPOINT ["top", "-b"]

#
# Install OpenJDK and Gradle
#
RUN apt-get update && apt-get install -y openjdk-17-jdk curl
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install gradle"

#
# Build stage
#
FROM openjdk:17 AS build
WORKDIR /app
COPY . /app/
RUN apk update && apk add --no-cache curl
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install gradle"
RUN ./gradlew clean build

#
# Package stage
#
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/app.jar
EXPOSE 5432
ENTRYPOINT ["java", "-jar", "app.jar"]
