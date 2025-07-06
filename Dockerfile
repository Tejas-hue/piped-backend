# -------- STAGE 1: Build the app --------
FROM eclipse-temurin:21-jdk-alpine AS build

# Install build tools
RUN apk add --no-cache bash git curl unzip

# Set working directory
WORKDIR /app

# Copy all source code into the container
COPY . .

# Make the Gradle wrapper executable
RUN chmod +x ./gradlew

# Build the app (skip tests)
RUN ./gradlew build -x test

# -------- STAGE 2: Run the app --------
FROM eclipse-temurin:21-jdk-alpine

# Set working directory
WORKDIR /app

# Copy all jar files from the build stage
COPY --from=build /app/build/libs/ ./libs/

# Rename the actual built jar to piped.jar
RUN cp ./libs/*.jar ./piped.jar

# Set environment variable fallback for port
ENV PORT=8080

# Expose port
EXPOSE 8080

# Start the app using the provided JDBC_URL from Render
CMD ["sh", "-c", "java -Djdbc.url=$JDBC_URL -Dserver.port=$PORT -jar piped.jar"]
