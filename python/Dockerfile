# Traditional approach - Single stage with everything
FROM python:3.11

WORKDIR /app

# Install system dependencies and build tools (stays in final image)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install poetry and development tools (stays in final image)
RUN pip install poetry pytest black flake8 mypy ipython

# Copy all files including development files
COPY . .

# Install ALL dependencies including dev dependencies (stays in final image)
RUN poetry install --with dev

EXPOSE 8000
CMD ["python", "-m", "app.main"]
