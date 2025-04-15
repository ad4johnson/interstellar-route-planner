from prometheus_fastapi_instrumentator import Instrumentator
from fastapi import FastAPI

app = FastAPI()
Instrumentator().instrument(app).expose(app)