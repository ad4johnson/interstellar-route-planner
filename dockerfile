# Use Python as the base image
FROM python:3.9-slim-bullseye

# Install system packages
RUN apt update && apt install -y nodejs npm postgresql-client

# Set working directory
WORKDIR /app

# Copy only requirements first for Docker caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY ./app /app/app
COPY ./models /app/models

# Set PYTHONPATH to /app so we can import from app.*
ENV PYTHONPATH=/app

# Expose port
EXPOSE 8000

# Run the app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]