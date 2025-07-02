# Traditional approach - Single stage with everything
FROM maven:3.8-openjdk-17

WORKDIR /app

# Install additional system tools (stays in final image)
RUN microdnf update && microdnf install -y \
    curl \
    wget \
    git \
    vim \
    && microdnf clean all

# Copy all project files including development files
COPY . .

# Build the application (Maven cache and build tools stay in final image)
RUN mvn package -DskipTests

EXPOSE 8080
CMD ["java", "-jar", "target/*.jar"]
