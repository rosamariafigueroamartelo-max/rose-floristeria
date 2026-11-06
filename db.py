"""Manejo de la conexión a MySQL con el driver nativo (sin ORM)."""
from contextlib import contextmanager

import mysql.connector
from mysql.connector import Error

from app.config import DB_CONFIG


@contextmanager
def obtener_cursor():
    """Abre una conexión, entrega un cursor que devuelve diccionarios y
    garantiza el cierre de ambos aunque ocurra una excepción."""
    conexion = None
    cursor = None
    try:
        conexion = mysql.connector.connect(**DB_CONFIG)
        cursor = conexion.cursor(dictionary=True)
        yield cursor
    finally:
        if cursor is not None:
            cursor.close()
        if conexion is not None and conexion.is_connected():
            conexion.close()


def consultar(sql: str, parametros: tuple = ()) -> list[dict]:
    """Ejecuta una sentencia SELECT con parámetros posicionales (%s)."""
    with obtener_cursor() as cursor:
        cursor.execute(sql, parametros)
        return cursor.fetchall()


def consultar_uno(sql: str, parametros: tuple = ()) -> dict | None:
    with obtener_cursor() as cursor:
        cursor.execute(sql, parametros)
        return cursor.fetchone()


__all__ = ["consultar", "consultar_uno", "Error"]
