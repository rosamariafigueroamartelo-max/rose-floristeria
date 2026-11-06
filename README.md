# Rose Floristería · API REST de Analítica (Python + SQL nativo)

API en **FastAPI** conectada a la base de datos MySQL del proyecto Rose Floristería. Expone 5 endpoints de analítica de negocio; todo el cálculo se hace en el motor con SQL crudo (subconsultas + `GROUP BY`), sin ORM.

La homologación de entidades y la explicación de cada endpoint están en [HOMOLOGACION.md](HOMOLOGACION.md).

## Estructura del repositorio

```
rose-api/
├── app/
│   ├── main.py            # Aplicación FastAPI, registro de rutas y manejadores de error
│   ├── config.py          # Variables de entorno y estados del negocio
│   ├── db.py              # Conexión y cursor nativo (context manager)
│   ├── respuestas.py      # Formato JSON homogéneo (200 / 404 / 500)
│   ├── sql/
│   │   └── consultas.py   # Las 5 sentencias SQL crudas
│   └── routers/
│       ├── reportes.py    # 1. /api/reportes/clasificacion-top
│       ├── analitica.py   # 2. /api/analitica/actores-estrella
│       ├── items.py       # 3. /api/items/desviacion-grupo
│       ├── segmentos.py   # 4. /api/segmentos/analisis-limpio
│       └── operaciones.py # 5. /api/operaciones/resumen-dinamico
├── database/
│   └── dump_proyecto.sql  # Avance 1 (DDL + DML) + datos adicionales
├── tests/
│   ├── test_endpoints.http
│   └── RoseFloristeria_API.postman_collection.json
├── HOMOLOGACION.md
├── requirements.txt
└── .env.example
```

## Instalación y ejecución

Requisitos: Python 3.10+ y MySQL 8.0+.

```bash
# 1. Crear la base de datos con datos de prueba
mysql -u root -p < database/dump_proyecto.sql

# 2. Entorno virtual y dependencias
python -m venv venv
venv\Scripts\activate          # Windows
# source venv/bin/activate     # Linux / macOS
pip install -r requirements.txt

# 3. Configurar la conexión
copy .env.example .env         # Windows  (cp en Linux/macOS)
#   y editar DB_PASSWORD

# 4. Levantar la API
uvicorn app.main:app --reload
```

Documentación interactiva: <http://127.0.0.1:8000/docs>

## Endpoints

| # | Ruta | Patrón SQL |
|---|---|---|
| 1 | `GET /api/reportes/clasificacion-top` | GROUP BY categoría + subconsulta escalar en HAVING |
| 2 | `GET /api/analitica/actores-estrella` | GROUP BY cliente + tabla derivada en FROM / HAVING |
| 3 | `GET /api/items/desviacion-grupo` | GROUP BY producto + subconsulta correlacionada en HAVING |
| 4 | `GET /api/segmentos/analisis-limpio` | GROUP BY administrador + NOT EXISTS en WHERE |
| 5 | `GET /api/operaciones/resumen-dinamico?min_operaciones=2` | GROUP BY estado del pedido + HAVING COUNT >= %s + subconsulta MIN |

### Formato de respuesta

```json
{
  "estado": 200,
  "endpoint": "/api/operaciones/resumen-dinamico",
  "descripcion": "Estados de pedido que alcanzan el mínimo de pedidos y superan el producto más económico",
  "parametros": { "min_operaciones": 10 },
  "total_registros": 3,
  "datos": [
    { "estado": "Entregado", "numero_pedidos": 25, "valor_total": 6070000.0,
      "promedio_por_pedido": 242800.0, "precio_producto_mas_economico": 25000.0 }
  ]
}
```

Sin registros → `404` con `"error"`; fallo de base de datos → `500`.

## Pruebas

- **VS Code / JetBrains:** abrir `tests/test_endpoints.http` y ejecutar cada petición.
- **Postman:** *Import* → `tests/RoseFloristeria_API.postman_collection.json` (incluye tests que verifican 200 y datos no vacíos).
