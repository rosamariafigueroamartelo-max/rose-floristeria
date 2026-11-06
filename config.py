"""Configuración de la conexión leída desde variables de entorno (.env)."""
import os

try:  # python-dotenv es opcional: si está instalado, carga el archivo .env
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD", ""),
    "database": os.getenv("DB_NAME", "rose_floristeria"),
}

# Estados del negocio usados como parámetros (nunca se concatenan en el SQL)
# Estado crítico de un pedido (PEDIDO.estado)
ESTADO_PEDIDO_CANCELADO = "Cancelado"
