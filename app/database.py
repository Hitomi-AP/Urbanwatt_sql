import os
import psycopg
from dotenv import load_dotenv
from pathlib import Path
ENV_PATH = Path(__file__).resolve().parent.parent / "infra" / ".env"
print(ENV_PATH)

load_dotenv(dotenv_path=ENV_PATH)

def get_connection():
    return psycopg.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD")
    )
