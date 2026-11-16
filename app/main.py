from fastapi import FastAPI, HTTPException
from app.database import get_connection
from dotenv import load_dotenv

load_dotenv()
app = FastAPI(
    title="API Stations",
    description="API de gestion des stations et des bornes",
    version="1.0.0"
)

@app.get("/health")
def health_check():
    return{"Health":"OK"}


# GET /api/stations
@app.get("/api/stations")
def get_stations():

    try:
        with get_connection() as conn:
            with conn.cursor() as cursor:

                cursor.execute("""
                    SELECT id, nom, adresse
                    FROM stations
                """)

                stations = cursor.fetchall()

                return [
                    {
                        "id": station[0],
                        "nom": station[1],
                        "adresse": station[2]
                    }
                    for station in stations
                ]

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


# GET /api/stations/{id}/bornes
@app.get("/api/stations/{id}/bornes")
def get_bornes(id: int):

    try:
        with get_connection() as conn:
            with conn.cursor() as cursor:

                # Vérifier que la station existe
                cursor.execute(
                    "SELECT id FROM stations WHERE id = %s",
                    (id,)
                )

                station = cursor.fetchone()

                if station is None:
                    raise HTTPException(
                        status_code=404,
                        detail="Station introuvable"
                    )

                # Récupérer les bornes de la station
                cursor.execute("""
                    SELECT id, nom, puissance, disponible
                    FROM bornes
                    WHERE station_id = %s
                """, (id,))

                bornes = cursor.fetchall()

                return [
                    {
                        "id": borne[0],
                        "nom": borne[1],
                        "puissance": borne[2],
                        "disponible": borne[3]
                    }
                    for borne in bornes
                ]

    except HTTPException:
        raise

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )