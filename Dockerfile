
ARG TARGETPLATFORM=linux/amd64

FROM --platform=${TARGETPLATFORM} node:20 AS front-builder
WORKDIR /app/frontend
COPY ./frontend .
RUN npm ci && npm run build

FROM --platform=${TARGETPLATFORM} gradle:8-jdk17 AS backend-builder
WORKDIR /app
# копируем конфиги
COPY build.gradle.kts .
COPY settings.gradle.kts .
COPY gradlew .
COPY gradlew.bat .
COPY gradle/ gradle/
# копируем java код
COPY src/ src/

COPY --from=front-builder /app/frontend/dist/. ./src/main/resources/static/
RUN ./gradlew build -x test

FROM --platform=${TARGETPLATFORM} eclipse-temurin:17-jre
WORKDIR /app
COPY --from=backend-builder /app/build/libs/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
