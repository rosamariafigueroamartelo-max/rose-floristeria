"""Formato homogéneo de respuestas JSON para todos los endpoints."""
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse


def exito(endpoint: str, descripcion: str, datos: list[dict], **extra) -> JSONResponse:
    """200 si hay registros; 404 si la consulta no devolvió filas."""
    if not datos:
        return error(404, endpoint, "No se encontraron registros que cumplan los criterios.")
    cuerpo = {
        "estado": 200,
        "endpoint": endpoint,
        "descripcion": descripcion,
        **extra,
        "total_registros": len(datos),
        "datos": datos,
    }
    # jsonable_encoder convierte Decimal y date de MySQL a tipos JSON
    return JSONResponse(status_code=200, content=jsonable_encoder(cuerpo))


def error(codigo: int, endpoint: str, mensaje: str) -> JSONResponse:
    return JSONResponse(
        status_code=codigo,
        content={"estado": codigo, "endpoint": endpoint, "error": mensaje, "datos": []},
    )
