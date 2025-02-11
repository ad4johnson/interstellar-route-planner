FROM python:3.9-slim

WORKDIR /app

COPY . /app

ENV PYTHONPATH=/app

RUN apt update && apt install -y postgresql-client  # Install psql
RUN pip install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]