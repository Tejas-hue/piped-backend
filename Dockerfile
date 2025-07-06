FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Install build tools
RUN apk add --no-cache git gradle

# Clone and build the app
RUN git clone https://github.com/TeamPiped/Piped-Backend.git . && \
    ./gradlew build -x test

# Set environment variable fallback
ENV PORT=8080

# Expose the port
EXPOSE 8080

# Run the app using JDBC_URL from environment
CMD ["sh", "-c", "java -Djdbc.url=$JDBC_URL -Dserver.port=$PORT -jar build/libs/piped.jar"]
