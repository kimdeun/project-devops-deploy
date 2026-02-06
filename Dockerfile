FROM node:20 as front-builder
WORKDIR /app/frontend
COPY ./frontend .
RUN npm ci && npm run build

FROM gradle:8-jdk17 AS backend-builder
WORKDIR /app
# копируем конфиги
COPY build.gradle.kts .
COPY settings.gradle.kts .
COPY gradlew .
COPY gradlew.bat .
COPY gradle/ gradle/
# копируем java код
COPY src/ src/

COPY --from=front-builder /app/frontend/dist/* ./src/main/resources/static/
RUN ./gradlew build -x test

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=backend-builder /app/build/libs/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
