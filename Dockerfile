FROM openjdk:17 AS build
WORKDIR /app
COPY . /app/
RUN apt-get update && apt-get install -y curl
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install gradle"
RUN gradle clean build

#
# Clear Gradle Wrapper
#
RUN rm gradlew gradlew.bat

#
# Package stage
#
FROM openjdk:17-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
