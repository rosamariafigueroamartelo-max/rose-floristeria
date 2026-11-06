"""Rose Floristería · API REST de Analítica (FastAPI + SQL nativo).

Ejecutar:  uvicorn app.main:app --reload
Docs:      http://127.0.0.1:8000/docs
"""
import logging

from fastapi import FastAPI, Request
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException

from app.routers import analitica, items, operaciones, reportes, segmentos

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")

app = FastAPI(
    title="Rose Floristería · API de Analítica",
    description="Rose Floristería: gestión de pedidos de flores y arreglos. "
                "5 endpoints analíticos con SQL crudo (subconsultas + GROUP BY).",
    version="1.0.0",
)

for modulo in (reportes, analitica, items, segmentos, operaciones):
    app.include_router(modulo.router)


@app.get("/", tags=["Inicio"])
def inicio():
    return {
        "proyecto": "Rose Floristería",
        "endpoints": [
            "/api/reportes/clasificacion-top",
            "/api/analitica/actores-estrella",
            "/api/items/desviacion-grupo",
            "/api/segmentos/analisis-limpio",
            "/api/operaciones/resumen-dinamico?min_operaciones=2",
        ],
    }


# Respuestas homogéneas también para rutas inexistentes y parámetros inválidos
@app.exception_handler(StarletteHTTPException)
async def http_error(request: Request, exc: StarletteHTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"estado": exc.status_code, "endpoint": request.url.path, "error": exc.detail, "datos": []},
    )


@app.exception_handler(RequestValidationError)
async def validacion_error(request: Request, exc: RequestValidationError):
    return JSONResponse(
        status_code=422,
        content={"estado": 422, "endpoint": request.url.path, "error": "Parámetros inválidos",
                 "detalle": jsonable_encoder(exc.errors()), "datos": []},
    )


@app.exception_handler(Exception)
async def error_general(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={"estado": 500, "endpoint": request.url.path, "error": "Error interno del servidor", "datos": []},
    )
