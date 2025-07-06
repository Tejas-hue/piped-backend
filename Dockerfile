FROM eclipse-temurin:21-jdk-alpine AS build

# Install required tools
RUN apk add --no-cache bash git curl unzip

# Set workdir
WORKDIR /app

# Copy files
COPY . .

# Make Gradle wrapper executable
RUN chmod +x ./gradlew

# Build using wrapper (don't run tests)
RUN ./gradlew build -x test

# ---------------------------

FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy built JAR from previous stage
COPY --from=build /app/build/libs/piped.jar .

EXPOSE 8080
ENV PORT=8080

# Start the app using env-passed JDBC
CMD ["sh", "-c", "java -Djdbc.url=$JDBC_URL -Dserver.port=$PORT -jar piped.jar"]
