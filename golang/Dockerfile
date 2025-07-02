# Traditional approach - Single stage with everything
FROM golang:1.23

WORKDIR /app

# Install additional system tools (stays in final image)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    htop \
    strace \
    && rm -rf /var/lib/apt/lists/*

# Install additional Go tools (stays in final image)
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Copy all files including development files
COPY . .

# Download dependencies (cache stays in final image)
RUN go mod download

# Build the application (build cache stays in final image)
RUN go build -o app .

EXPOSE 8081
CMD ["./app"]
