from fastapi import FastAPI
import psycopg

app = FastAPI()

@app.get("/health")
def health_check():
    return{"Health":"OK"}
