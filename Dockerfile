FROM gradle:8.1.1-jdk17-alpine as build
WORKDIR /app

COPY . .

# Build the app without running tests
RUN gradle build -x test

# ------------------------------

FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

COPY --from=build /app/build/libs/piped.jar ./piped.jar

EXPOSE 8080
ENV PORT=8080

CMD ["sh", "-c", "java -Djdbc.url=$JDBC_URL -Dserver.port=$PORT -jar piped.jar"]
