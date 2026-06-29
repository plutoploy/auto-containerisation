FROM docker.io/eclipse-temurin:24 as builder
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests || gradle build -x test

FROM docker.io/eclipse-temurin:24
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
