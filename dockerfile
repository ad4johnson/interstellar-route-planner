FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy all files into container
COPY . /app

# Set Python path for module resolution
ENV PYTHONPATH=/app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]