# Use Python as the base image
FROM python:3.9-slim

# Install Node.js and npm
RUN apt update && apt install -y nodejs npm

# Set the working directory inside the container
WORKDIR /app

# Copy all project files
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Node.js dependencies globally
RUN npm install -g npx knex

# Expose the port your app runs on
EXPOSE 8000

# Run migrations and start the server
CMD ["sh", "-c", "npx knex migrate:latest && uvicorn app.main:app --host 0.0.0.0 --port 8000"]