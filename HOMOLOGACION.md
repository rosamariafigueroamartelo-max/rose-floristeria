# Documento de Homologación · Rose Floristería

**Proyecto:** Rose Floristería — sistema de gestión de pedidos de una floristería: catálogo de flores y arreglos por categoría, clientes, pedidos con su detalle y administradores que gestionan cada pedido.

**Esquema:** el del Avance 1 (`rose_floristeria.sql`), sin cambios de estructura: `ADMINISTRADOR`, `CLIENTE`, `CATEGORIA`, `PRODUCTO`, `PEDIDO`, `DETALLE_PEDIDO`.

## 1. Matriz de homologación de entidades

En mi proyecto de **floristería**:

| Rol arquetípico | Tabla / atributo en Rose Floristería | Justificación |
|---|---|---|
| **A. Entidad Catálogo / Clasificadora** | `CATEGORIA` | Agrupa los productos: rosas, ramos, orquídeas, condolencias, arreglos para bodas, etc. |
| **B. Entidad Ítem / Recurso** | `PRODUCTO` | Cada arreglo o producto con su precio, stock, color, tamaño y tipo de flor. |
| **C. Entidad Transaccional (Cabecera)** | `PEDIDO` | Venta con fecha, estado, dirección de entrega y total. |
| **C. Entidad Transaccional (Detalle)** | `DETALLE_PEDIDO` | Productos de cada pedido: cantidad × precio unitario. |
| **D. Entidad Actor / Sujeto** | `CLIENTE` | Personas que compran en la floristería. |
| **E. Entidad de Contexto / Segmentación** | `ADMINISTRADOR` | Divide organizativamente la operación: cada pedido es gestionado por un administrador. |
| Atributo operativo (Endpoint 5) | `PEDIDO.estado` | Entregado, Pendiente, En preparacion, Cancelado. |
| Estado crítico (Endpoint 4) | `PEDIDO.estado = 'Cancelado'` | Clientes con pedidos cancelados se excluyen del análisis limpio. |

**Regla de negocio común:** el valor de un pedido es `PEDIDO.total`, que coincide con la suma de `cantidad × precio_unitario` de su detalle. Los pedidos en estado `Cancelado` no cuentan como venta (excepto en el Endpoint 3, que mide el movimiento de inventario, y en el Endpoint 5, que audita todos los estados).

**Datos adicionales:** el script `dump_proyecto.sql` contiene primero el DDL y DML originales del Avance 1 sin modificar, y luego datos adicionales con la misma estructura: un segundo producto por categoría (para poder comparar cada producto contra su propia categoría), 30 pedidos más con varios productos cada uno (para que los clientes y administradores tengan varios pedidos) y tres pedidos en estado `Cancelado`.

## 2. ¿Qué responde cada endpoint en el negocio?

### 1. `GET /api/reportes/clasificacion-top`
**Patrón:** `GROUP BY CATEGORIA` + subconsulta escalar en `HAVING`.
**Pregunta de negocio:** *¿Qué categorías dejan más dinero por cada línea vendida que el promedio de toda la floristería?*
Agrupa las líneas de `DETALLE_PEDIDO` por categoría, muestra recaudo total y promedio por línea, y conserva solo las categorías cuyo promedio es estrictamente mayor que el promedio global. Ayuda a decidir qué líneas promocionar (por ejemplo arreglos para bodas y flores preservadas).

### 2. `GET /api/analitica/actores-estrella`
**Patrón:** `GROUP BY CLIENTE` + `SUM` + subconsulta en `HAVING` que opera sobre una **tabla derivada** en su `FROM`.
**Pregunta de negocio:** *¿Qué clientes han gastado en total más que el cliente promedio?*
Suma `PEDIDO.total` por cliente y lo compara con el promedio del gasto acumulado de todos los clientes, calculado sobre una tabla derivada. Identifica a los clientes más valiosos para fidelizarlos.

### 3. `GET /api/items/desviacion-grupo`
**Patrón:** `GROUP BY PRODUCTO` + **subconsulta correlacionada** en `HAVING`.
**Pregunta de negocio:** *¿Qué productos se venden menos que los demás productos de su misma categoría?*
Para cada producto se cuentan las unidades vendidas y se comparan con el promedio de unidades por producto de **su propia** categoría (la subconsulta usa `P.id_categoria` de la fila externa). Detecta productos de baja rotación; en una floristería es clave porque las flores son perecederas.

### 4. `GET /api/segmentos/analisis-limpio`
**Patrón:** `GROUP BY ADMINISTRADOR` + subconsulta de exclusión `NOT EXISTS` en `WHERE`.
**Pregunta de negocio:** *¿Cuánto vende cada administrador si dejo por fuera a los clientes que han cancelado pedidos?*
Consolida pedidos gestionados, clientes atendidos y total vendido por administrador, excluyendo todos los pedidos de clientes que tengan algún pedido en estado `Cancelado`. Da una visión de la venta "sana" que gestiona cada administrador.

### 5. `GET /api/operaciones/resumen-dinamico?min_operaciones=N`
**Patrón:** `GROUP BY PEDIDO.estado` + parámetro dinámico en `HAVING COUNT(*) >= %s` + subconsulta escalar `MIN(precio)` contra el catálogo `PRODUCTO`.
**Pregunta de negocio:** *¿Qué estados de pedido acumulan al menos N pedidos y tienen un valor medio mayor que el producto más económico del catálogo?*
El parámetro `min_operaciones` es opcional (por defecto 2) y se inyecta con marcador `%s`. Permite auditar en qué estado está concentrado el dinero de los pedidos (entregado, pendiente, en preparación o cancelado).

## 3. Cumplimiento de las reglas técnicas

| Regla | Cómo se cumple |
|---|---|
| Sin ORM | Se usa `mysql-connector-python` con `cursor.execute(sql, params)`. Todo el SQL está en `app/sql/consultas.py`. |
| Base de datos propia | Esquema del Avance 1 de Rose Floristería, sin cambios de estructura (`database/dump_proyecto.sql`). |
| Parametrización segura | El estado `'Cancelado'` y `min_operaciones` viajan como `%s` en una tupla; no hay concatenación ni f-strings en el SQL. |
| Respuestas homogéneas | Todas las rutas son `GET`, devuelven JSON con la misma forma (`estado`, `endpoint`, `descripcion`, `total_registros`, `datos`) y usan 200 / 404 (sin registros) / 500 (error de BD o interno). |
