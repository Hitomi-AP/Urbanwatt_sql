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
                    SELECT *
                    FROM stations
                """)

                stations = cursor.fetchall()
                print(stations)

                return [
                    {
                        "id": station[0],
                        "code": station[1],
                        "nom Station": station[2],
                        "ville": station[3],
                        "adresse": station[4],
                        "date ouverture": station[5]
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
                    "SELECT id_station FROM stations WHERE id_station = %s",
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
                    SELECT b.id_borne, b.id_station,s.code_station,b.code_borne,b.puissance_kw, b.connecteur,b.etat
                    FROM bornes b 
                    INNER JOIN stations s ON b.id_station = s.id_station
                    WHERE b.id_station = %s
                """, (id,))

                bornes = cursor.fetchall()

                return [
                    {
                        "id_borne": borne[0],
                        "id_station":borne[1],
                        "code_station":borne[2],
                        "code_borne":borne[3],
                        "puissance_borne":borne[4],
                        "connecteur":borne[5],
                        "etat_borne":borne[6]
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