# Documentación de KPIs — RideCode
## Pestaña: Operaciones

---

## Estructura de cada KPI

Cada KPI se documenta con dos secciones:

- **[Usuario]** — Información orientada al usuario final: qué muestra el KPI, cuándo se calcula la información, cómo se consulta, qué filtros aplican y notas visibles en el frontend.
- **[Técnico]** — Información orientada al equipo de desarrollo: fuente de datos, programa de agrupación, procedimientos, tabla de hechos, operaciones internas y textos de interfaz (tooltip y subtítulo en español e inglés).

> **Nota sobre la Descripción:** El campo *Descripción* de cada KPI es el texto que se muestra como **tooltip** en la página de KPIs y en el dashboard.

---

---

## KPI: Ocupación Promedio

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el porcentaje de ocupación promedio de los buses en el rango de fechas seleccionado, calculado como el promedio del cociente entre pasajeros transportados y capacidad del bus por cada servicio. Si no hay registros, devuelve 0.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta el porcentaje de ocupación promedio de los buses en un rango de fechas dentro de una zona franca, calculado como el promedio del cociente entre pasajeros transportados y capacidad del bus por cada servicio. Considera únicamente los servicios aprobados por cumplimiento de empresa de transporte. Retorna un único valor porcentual; si no hay registros, devuelve 0. La fecha se ajusta según la zona horaria configurada para la zona franca.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                     |
|---------------------------|---------------------------------------------------------------------------|
| Operación                 | Promedio del porcentaje de ocupación de los registros de `summaryService` |
| Tabla de hechos           | —                                                                         |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_AVERAGE_OCCUPANCY`                                  |

---

**Observación técnica**

Para empresas de **transporte** y **zona franca**, los datos se obtienen directamente de `summaryService`. Para empresas **cliente**, se debe obtener de `clientcompanyservice` (solo pasajeros pospago). La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el porcentaje de ocupación promedio de los buses en un rango de fechas dentro de una zona franca, calculado como el promedio del cociente entre pasajeros transportados y capacidad del bus por cada servicio. Considera únicamente los servicios aprobados por cumplimiento de empresa de transporte. Retorna un único valor porcentual; si no hay registros, devuelve 0. La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries the average bus occupancy percentage within a date range in a free trade zone, calculated as the average ratio between passengers transported and bus capacity per service. Only considers services approved by transport company compliance. Returns a single percentage value; if no records exist, returns 0. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Servicios Ocupación <70%

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la cantidad de servicios cuya ocupación fue menor al 70% de la capacidad del bus en el rango de fechas seleccionado. Se excluyen los buses con capacidad cero para evitar divisiones por cero.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Cuenta la cantidad de servicios cuya ocupación es menor al 70% de la capacidad del bus, en un rango de fechas dentro de una zona franca. Considera únicamente los servicios aprobados por cumplimiento de empresa de transporte y excluye buses con capacidad cero para evitar división por cero. Retorna un único valor con el total de servicios bajo ese umbral. La fecha se ajusta según la zona horaria configurada para la zona franca.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                       |
|---------------------------|---------------------------------------------------------------------------------------------|
| Operación                 | Conteo de registros de `summaryService` donde la ocupación sea menor al 70% de la capacidad |
| Tabla de hechos           | —                                                                                           |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_SERVICES_LOW_OCCUPANCY`                                               |

---

**Observación técnica**

El umbral del **70%** debe definirse como una constante en el procedimiento. Se excluyen buses con capacidad igual a cero para evitar divisiones por cero. La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Cuenta la cantidad de servicios cuya ocupación es menor al 70% de la capacidad del bus, en un rango de fechas dentro de una zona franca. Considera únicamente los servicios aprobados por cumplimiento de empresa de transporte y excluye buses con capacidad cero para evitar división por cero. Retorna un único valor con el total de servicios bajo ese umbral. La fecha se ajusta según la zona horaria configurada para la zona franca. | Counts the number of services whose occupancy is less than 70% of the bus capacity, within a date range in a free trade zone. Only considers services approved by transport company compliance and excludes buses with zero capacity to avoid division by zero. Returns a single value with the total services below that threshold. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Distancia Promedio

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la distancia promedio de las rutas ejecutadas en los servicios aprobados por el transportista dentro del rango de fechas seleccionado. Solo considera rutas que tengan distancia definida. Si no hay registros, devuelve 0.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta la distancia promedio de las rutas ejecutadas en servicios aprobados, en un rango de fechas dentro de una zona franca. Solo considera rutas que tengan distancia definida (no nula). Retorna un único valor con el promedio; si no hay registros, devuelve 0. La fecha se ajusta según la zona horaria configurada para la zona franca.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                                            |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| Operación                 | Suma de distancias de los servicios aprobados por transportista dividida entre la cantidad de esos servicios (distancia promedio) |
| Tabla de hechos           | —                                                                                                                                |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_AVERAGE_DISTANCE`                                                                                          |

---

**Observación técnica**

Solo se consideran los servicios aprobados por el transportista y cuya ruta tenga distancia definida (no nula). La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta la distancia promedio de las rutas ejecutadas en servicios aprobados, en un rango de fechas dentro de una zona franca. Solo considera rutas que tengan distancia definida (no nula). Retorna un único valor con el promedio; si no hay registros, devuelve 0. La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries the average distance of routes executed in approved services, within a date range in a free trade zone. Only considers routes with a defined (non-null) distance. Returns a single value with the average; if no records exist, returns 0. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Población Total Activa

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la sumatoria de pasajeros activos registrados en la zona franca, tomando únicamente el dato del día más reciente dentro del rango de fechas seleccionado. Si no hay registros, no retorna filas.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente de forma **programada todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario. Cada ejecución registra el conteo de pasajeros activos con la fecha de ejecución.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario puede seleccionar el rango de fechas (fecha inicio y fecha fin) para definir el período de consulta; el sistema retornará el dato del día más reciente disponible dentro de ese rango.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | NO      |
| Ramal        | NO      |
| Tipo de ruta | NO      |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta la población activa (pasajeros activos) registrada en una zona franca, tomando únicamente el dato del día más reciente dentro del rango de fechas. Retorna la sumatoria de pasajeros activos de ese día; si no hay registros, no retorna filas.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | NO      |
| Ramal        | NO      |
| Tipo de ruta | NO      |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                                       |
|-------------------------------------|-----------------------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                                          |
| Evento disparador                   | Ejecución diaria a las 00:00 (hora de la zona franca según su zona horaria) |
| Tópico en la cola                   | —                                                                           |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_ACTIVE_POPULATION_AGGREGATION`                            |
| Parámetros procedimiento agrupación | —                                                                           |

> La agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria). No hay evento disparado por acciones de usuario ni cola asociada. Cada ejecución registra el conteo de pasajeros activos (distintos) con la fecha de ejecución.
>
> El programa de agrupación garantiza que cada día se genere un único registro por zona franca con el conteo actualizado de población activa.

---

**Operación y consulta**

| Campo                     | Valor                                              |
|---------------------------|----------------------------------------------------|
| Operación                 | Conteo de pasajeros distintos en estado activo     |
| Tabla de hechos           | `ACTIVE_POPULATION`                                |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_ACTIVE_POPULATION`           |

---

**Observación técnica**

Se contabilizan los pasajeros distintos que se encuentran en estado activo en la zona franca. La agrupación guarda el resultado con la fecha de ejecución del proceso. La consulta retorna el valor del día más reciente dentro del rango de fechas indicado.

La estructura de la tabla de hechos `ACTIVE_POPULATION` incluye: `id_población_activa`, `zona_franca`, `empresa_cliente`, `fecha` y `cantidad`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta la población activa (pasajeros activos) registrada en una zona franca, tomando únicamente el dato del día más reciente dentro del rango de fechas. Retorna la sumatoria de pasajeros activos de ese día; si no hay registros, no retorna filas. | Queries the active population (active passengers) registered in a free trade zone, taking only the most recent day's data within the date range. Returns the sum of active passengers for that day; if no records exist, no rows are returned. |
| Subtítulo  | — | — |

---

---

## KPI: Población Útil

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la sumatoria de pasajeros útiles (pasajeros distintos con viajes aprobados) registrados en la zona franca, tomando únicamente el dato del día más reciente dentro del rango de fechas seleccionado. Solo se consideran las transacciones exitosas (reading records).

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se realiza la **aprobación de un servicio** en el sistema.
- De forma **automática todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario puede definir turno, ramal, tipo de ruta y rango de fechas para acotar los resultados; el sistema retornará el dato del día más reciente disponible dentro de ese rango.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta la población útil (pasajeros distintos con viajes aprobados) registrada en una zona franca, tomando únicamente el dato del día más reciente dentro del rango de fechas. Retorna la sumatoria de pasajeros útiles de ese día; si no hay registros, no retorna filas.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                   |
|-------------------------------------|---------------------------------------------------------|
| Programa de agrupación              | SÍ                                                      |
| Evento disparador                   | Aprobación del servicio                                 |
| Tópico en la cola                   | `transport-compliance-approval`                 |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_USEFUL_POPULATION_AGGREGATION`        |
| Parámetros procedimiento agrupación | `summaryServiceId`                                      |

> El evento es disparado por la **aprobación de un servicio**, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `transport-compliance-approval` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que solo se contabilicen pasajeros distintos con transacciones exitosas (reading records), actualizando el registro correspondiente en la tabla de hechos.

---

**Operación y consulta**

| Campo                     | Valor                                                                 |
|---------------------------|-----------------------------------------------------------------------|
| Operación                 | Conteo de pasajeros distintos que viajaron con transacciones exitosas |
| Tabla de hechos           | `USEFUL_POPULATION`                                                   |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_USEFUL_POPULATION`                              |

---

**Observación técnica**

Solo se contabilizan pasajeros distintos que hayan viajado en servicios con transacciones exitosas (reading records). La consulta retorna el valor del día más reciente dentro del rango de fechas indicado.

La estructura de la tabla de hechos `USEFUL_POPULATION` incluye: `id_población_activa`, `zona_franca`, `empresa_cliente`, `empresa_transporte`, `turno`, `ramal`, `tiporuta`, `fecha` y `cantidad`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta la población útil (pasajeros distintos con viajes aprobados) registrada en una zona franca, tomando únicamente el dato del día más reciente dentro del rango de fechas. Retorna la sumatoria de pasajeros útiles de ese día; si no hay registros, no retorna filas. | Queries the useful population (distinct passengers with approved trips) registered in a free trade zone, taking only the most recent day's data within the date range. Returns the sum of useful passengers for that day; if no records exist, no rows are returned. |
| Subtítulo  | — | — |

---

---

## KPI: Apertura de Ruta

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el total de rutas distintas aperturadas (creadas) dentro del rango de fechas seleccionado en la zona franca, filtradas por ramal y tipo de ruta.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros definidos por el usuario: ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | NO      |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Cuenta el total de rutas distintas aperturadas (creadas) dentro de un rango de fechas en una zona franca. La conversión de zona horaria se realiza de forma inversa: en lugar de ajustar la fecha de los registros, convierte los límites del rango a UTC para filtrar directamente sobre el campo CreationDate de la ruta. Retorna un único valor con el conteo de rutas únicas.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | NO      |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                        |
|---------------------------|----------------------------------------------------------------------------------------------|
| Operación                 | Conteo de rutas distintas creadas en el período, filtrando por `CreationDate` y tipo de ruta |
| Tabla de hechos           | —                                                                                            |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_ROUTE_OPENING`                                                         |

---

**Observación técnica**

La conversión de zona horaria se realiza de forma inversa: en lugar de ajustar la fecha de los registros, se convierten los límites del rango de fechas indicado a UTC para filtrar directamente sobre el campo `CreationDate` de la ruta.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Cuenta el total de rutas distintas aperturadas (creadas) dentro de un rango de fechas en una zona franca. La conversión de zona horaria se realiza de forma inversa: en lugar de ajustar la fecha de los registros, convierte los límites del rango a UTC para filtrar directamente sobre el campo CreationDate de la ruta. Retorna un único valor con el conteo de rutas únicas. | Counts the total distinct routes opened (created) within a date range in a free trade zone. The time zone conversion is done in reverse: instead of adjusting the record dates, the range boundaries are converted to UTC to filter directly on the route's CreationDate field. Returns a single value with the count of unique routes. |
| Subtítulo  | — | — |

---

---

## KPI: Tiempo Promedio de Servicio por Ramal

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el tiempo promedio de servicio (en formato HH:MM) para cada ramal, calculado como la diferencia en minutos entre la hora de inicio y la hora de llegada al destino de los servicios aprobados. El resultado se presenta ordenado de mayor a menor tiempo promedio con soporte de paginación.

Retorna dos conjuntos de información:
1. **Total de ramales** — para la paginación.
2. **Listado paginado** — ramales con su tiempo promedio.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta el tiempo promedio de servicio por ramal en un rango de fechas dentro de una zona franca, calculado como la diferencia en minutos entre la hora de inicio y la hora de llegada al destino de cada servicio. Solo considera servicios aprobados por cumplimiento de empresa de transporte que tengan hora de llegada registrada. El resultado se presenta en formato HH:MM, ordenado de mayor a menor tiempo promedio y con soporte de paginación. Retorna dos conjuntos de resultados: el total de ramales para paginación y el listado paginado de ramales con su tiempo promedio. La fecha se ajusta según la zona horaria configurada para la zona franca.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                 |
|---------------------------|-------------------------------------------------------------------------------------------------------|
| Operación                 | Listado de duraciones promedio por ramal desde `summaryService`, paginado y ordenado de mayor a menor |
| Tabla de hechos           | —                                                                                                     |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_AVG_SERVICE_TIME_BY_BRANCH`                                                     |

---

**Observación técnica**

Solo se consideran servicios aprobados por cumplimiento de empresa de transporte que tengan hora de llegada al destino registrada. El tiempo se calcula como la diferencia en minutos entre la hora de inicio y la hora de llegada al destino, presentado en formato HH:MM. La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el tiempo promedio de servicio por ramal en un rango de fechas dentro de una zona franca, calculado como la diferencia en minutos entre la hora de inicio y la hora de llegada al destino de cada servicio. Solo considera servicios aprobados por cumplimiento de empresa de transporte que tengan hora de llegada registrada. El resultado se presenta en formato HH:MM, ordenado de mayor a menor tiempo promedio y con soporte de paginación. Retorna dos conjuntos de resultados: el total de ramales para paginación y el listado paginado de ramales con su tiempo promedio. La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries the average service time per branch within a date range in a free trade zone, calculated as the difference in minutes between the start time and the destination arrival time of each service. Only considers services approved by transport company compliance that have a recorded arrival time. The result is presented in HH:MM format, ordered from highest to lowest average time with pagination support. Returns two result sets: the total number of branches for pagination and the paginated list of branches with their average time. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Promedio de Abordaje por Parada

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el Top 10 de paradas con mayor promedio de abordajes en el rango de fechas seleccionado, ordenadas de mayor a menor. Los registros sin parada asociada se agrupan bajo la etiqueta "Sin parada".

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se realiza la **aprobación en el informe de cumplimiento por parte del transportista**.
- De forma **automática todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario puede definir turno, ramal, tipo de ruta y rango de fechas para acotar los resultados.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta el Top 10 de paradas con mayor promedio de abordajes en un rango de fechas dentro de una zona franca, ordenadas de mayor a menor. Los registros sin parada asociada se agrupan bajo la etiqueta "Sin parada". A diferencia de otros procedimientos, el filtro de fecha se aplica directamente sobre BoardingDate sin ajuste de zona horaria, ya que dicho campo se almacena como fecha local.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                                             |
|-------------------------------------|-----------------------------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                                                |
| Evento disparador                   | Aprobación en informe de cumplimiento por parte del transportista                 |
| Tópico en la cola                   | `transport-compliance-approval`                                                   |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_STOP_BOARDING_AGGREGATION`                                      |
| Parámetros procedimiento agrupación | `SummaryServiceId`                                                                |

> El evento es disparado por la **aprobación en el informe de cumplimiento por parte del transportista**, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `transport-compliance-approval` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación realiza un MERGE calculando la cantidad de pasajeros por parada, garantizando que múltiples eventos sobre el mismo servicio no generen registros duplicados.

---

**Operación y consulta**

| Campo                     | Valor                                                          |
|---------------------------|----------------------------------------------------------------|
| Operación                 | MERGE de cantidad de pasajeros agrupada por parada             |
| Tabla de hechos           | `STOP_BOARDING`                                                |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_AVG_BOARDING_BY_STOP`                    |

---

**Observación técnica**

La cantidad de abordajes por parada se obtiene de los reading records, representando los abordajes según las paradas registradas. El filtro de fecha se aplica directamente sobre `BoardingDate` sin ajuste de zona horaria, ya que dicho campo se almacena como fecha local.

La estructura de la tabla de hechos `STOP_BOARDING` incluye: `id_abordaje_parada`, `zona franca`, `empresa cliente`, `empresa transporte`, `turno`, `ramal`, `tipo de ruta`, `Fecha`, `Parada` y `Cantidad`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el Top 10 de paradas con mayor promedio de abordajes en un rango de fechas dentro de una zona franca, ordenadas de mayor a menor. Los registros sin parada asociada se agrupan bajo la etiqueta "Sin parada". A diferencia de otros procedimientos, el filtro de fecha se aplica directamente sobre BoardingDate sin ajuste de zona horaria, ya que dicho campo se almacena como fecha local. | Queries the Top 10 stops with the highest average boardings within a date range in a free trade zone, ordered from highest to lowest. Records without an associated stop are grouped under the label "No stop". Unlike other procedures, the date filter is applied directly on BoardingDate without time zone adjustment, as this field is stored as local date. |
| Subtítulo  | — | — |

---

---

## KPI: Servicios por Turno

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el Top 10 de ramales con mayor cantidad de servicios realizados en el rango de fechas seleccionado, desglosando el total por turno para cada ramal. Los resultados se ordenan por total acumulado de servicios del ramal de mayor a menor y, dentro de cada ramal, por nombre de turno alfabéticamente.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta el Top 10 de ramales con mayor cantidad de servicios realizados en un rango de fechas dentro de una zona franca, desglosando el total por turno para cada ramal. Solo considera servicios aprobados por cumplimiento de empresa de transporte. El resultado se ordena por total acumulado de servicios del ramal de mayor a menor, y dentro de cada ramal por nombre de turno alfabéticamente. La fecha se ajusta según la zona horaria configurada para la zona franca.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                             |
|---------------------------|-----------------------------------------------------------------------------------|
| Operación                 | Conteo de servicios agrupados por ramal y turno para el rango de fechas y filtros |
| Tabla de hechos           | —                                                                                 |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_SERVICES_BY_SHIFT`                                          |

---

**Observación técnica**

Solo se consideran los servicios aprobados por cumplimiento de empresa de transporte. La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el Top 10 de ramales con mayor cantidad de servicios realizados en un rango de fechas dentro de una zona franca, desglosando el total por turno para cada ramal. Solo considera servicios aprobados por cumplimiento de empresa de transporte. El resultado se ordena por total acumulado de servicios del ramal de mayor a menor, y dentro de cada ramal por nombre de turno alfabéticamente. La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries the Top 10 branches with the highest number of services performed within a date range in a free trade zone, breaking down the total by shift for each branch. Only considers services approved by transport company compliance. The result is ordered by the accumulated total of branch services from highest to lowest, and within each branch alphabetically by shift name. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Top de Sector

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el Top 10 de sectores con mayor cantidad de pasajeros transportados en el rango de fechas seleccionado, considerando únicamente servicios aprobados por cumplimiento de empresa de transporte. Se excluyen los sectores sin pasajeros y los resultados se ordenan de mayor a menor por total de pasajeros.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta el Top 10 de sectores con mayor cantidad de pasajeros transportados en un rango de fechas dentro de una zona franca, considerando únicamente servicios aprobados por cumplimiento de empresa de transporte y excluyendo sectores sin pasajeros. El resultado se ordena de mayor a menor por total de pasajeros. La fecha se ajusta según la zona horaria configurada para la zona franca.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                               |
|---------------------------|---------------------------------------------------------------------------------------------------------------------|
| Operación                 | Conteo por sector de los servicios atendidos para el turno, ramal, tipo de ruta y rango de fechas (basado en lógica de Top por Ruta) |
| Tabla de hechos           | —                                                                                                                   |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_TOP_SECTORS`                                                                                  |

---

**Observación técnica**

Solo se consideran los servicios aprobados por cumplimiento de empresa de transporte. La lógica sigue el mismo patrón del KPI Top por Ruta, adaptado para agrupación por sector (que pertenece a un ramal). La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

> **Nota de interfaz:** El texto _"Solo se considera los servicios aprobados por transportista"_ debe mostrarse al pie de la página en color tenue y en texto de menor tamaño. Esta indicación aplica para todas las páginas.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el Top 10 de sectores con mayor cantidad de pasajeros transportados en un rango de fechas dentro de una zona franca, considerando únicamente servicios aprobados por cumplimiento de empresa de transporte y excluyendo sectores sin pasajeros. El resultado se ordena de mayor a menor por total de pasajeros. La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries the Top 10 sectors with the highest number of passengers transported within a date range in a free trade zone, considering only services approved by transport company compliance and excluding sectors with no passengers. The result is ordered from highest to lowest by total passengers. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Participación por Tipo de Ruta

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la participación porcentual de los servicios agrupados por tipo de ruta, presentada mediante dos gráficos de tipo pie:

- **Pie 1** — Participación por empresa de transporte y tipo de ruta.
- **Pie 2** — Participación por empresa cliente. Los servicios sin empresa cliente asociada se agrupan bajo "Sin empresa".

Los porcentajes se calculan sobre el total global de servicios del conjunto filtrado.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta la participación porcentual de servicios en un rango de fechas dentro de una zona franca, considerando únicamente servicios aprobados por cumplimiento de empresa de transporte. Los porcentajes se calculan sobre el total global de servicios del conjunto filtrado. Retorna dos conjuntos de resultados: el primero con el porcentaje de participación por empresa de transporte y tipo de ruta, y el segundo con el porcentaje de participación por empresa cliente. Los servicios sin empresa cliente asociada se agrupan bajo "Sin empresa". La fecha se ajusta según la zona horaria configurada para la zona franca.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                                                      |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| Operación                 | Conteo de servicios por transportista-tiporuta y por empresa cliente-tiporuta; cálculo de proporción frente al total para devolver el porcentaje |
| Tabla de hechos           | —                                                                                                                                          |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_ROUTE_TYPE_PARTICIPATION`                                                                                            |

---

**Observación técnica**

Solo se consideran los servicios aprobados por cumplimiento de empresa de transporte. Los porcentajes se calculan sobre el total global del conjunto filtrado. Los servicios sin empresa cliente asociada se agrupan bajo "Sin empresa". La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

> **Nota de interfaz:** El texto _"Solo se considera los servicios aprobados por transportista"_ debe mostrarse al pie de la página en color tenue y en texto de menor tamaño. Esta indicación aplica para todas las páginas.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta la participación porcentual de servicios en un rango de fechas dentro de una zona franca, considerando únicamente servicios aprobados por cumplimiento de empresa de transporte. Los porcentajes se calculan sobre el total global de servicios del conjunto filtrado. Retorna dos conjuntos de resultados: el primero con el porcentaje de participación por empresa de transporte y tipo de ruta, y el segundo con el porcentaje de participación por empresa cliente. Los servicios sin empresa cliente asociada se agrupan bajo "Sin empresa". La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries the percentage participation of services within a date range in a free trade zone, considering only services approved by transport company compliance. Percentages are calculated over the global total of services in the filtered set. Returns two result sets: the first with the percentage of participation by transport company and route type, and the second with the percentage of participation by client company. Services without an associated client company are grouped under "No company". The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Mapa de Calor — Ubicación de Pasajeros

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra un mapa de calor de la ubicación de pasajeros, construido a partir de la agrupación de coordenadas geográficas (latitud y longitud) por grupos según un radio parametrizado. La intensidad de cada punto se normaliza entre 0 y 1 en función de la cantidad de pasajeros (dividida entre el máximo del conjunto filtrado). Si no hay registros o el máximo es cero, la intensidad se fija en 0.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente de forma **programada todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario. La agrupación se realiza para turno, ramal y tipo de ruta con la fecha de ejecución del proceso.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario puede definir turno, ramal, tipo de ruta y rango de fechas para acotar los resultados.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta los puntos de densidad de pasajeros por coordenada geográfica en un rango de fechas dentro de una zona franca, para construir un mapa de calor de ubicación de pasajeros. La intensidad de cada punto se normaliza entre 0 y 1 dividiendo la cantidad de pasajeros del punto entre el máximo encontrado en el conjunto filtrado. Si no hay registros o el máximo es cero, la intensidad se fija en 0. El resultado se ordena de mayor a menor intensidad.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                                       |
|-------------------------------------|-----------------------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                                          |
| Evento disparador                   | Ejecución diaria a las 00:00 (hora de la zona franca según su zona horaria) |
| Tópico en la cola                   | —                                                                           |
| Procedimiento de agrupación         | `PRC_KPI_AGREGACION_UBICACION_PASAJEROS`                                    |
| Parámetros procedimiento agrupación | —                                                                           |

> La agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria). No hay evento disparado por acciones de usuario ni cola asociada. Los pasajeros se agrupan por latitud y longitud según un radio parametrizado, para turno, ramal y tipo de ruta, con la fecha de ejecución del proceso.
>
> El radio de agrupación debe configurarse como un parámetro de zona franca; el valor por defecto es **1 km**.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                     |
|---------------------------|-----------------------------------------------------------------------------------------------------------|
| Operación                 | Agrupación de pasajeros por latitud y longitud según radio parametrizado, por turno, ramal y tipo de ruta |
| Tabla de hechos           | —                                                                                                         |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_PASSENGER_DENSITY`                                                                  |

---

**Observación técnica**

Los pasajeros se agrupan según un radio configurable por zona franca (por defecto: **1 km**). La tabla de hechos `DENSIDAD_PASAJEROS` incluye: `id_densidad_pasajeros`, `zona franca`, `empresa cliente`, `turno`, `ramal`, `Fecha`, `Latitud`, `Longitud` y `Cantidad`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta los puntos de densidad de pasajeros por coordenada geográfica en un rango de fechas dentro de una zona franca, para construir un mapa de calor de ubicación de pasajeros. La intensidad de cada punto se normaliza entre 0 y 1 dividiendo la cantidad de pasajeros del punto entre el máximo encontrado en el conjunto filtrado. Si no hay registros o el máximo es cero, la intensidad se fija en 0. El resultado se ordena de mayor a menor intensidad. | Queries passenger density points by geographic coordinate within a date range in a free trade zone, to build a heat map of passenger locations. The intensity of each point is normalized between 0 and 1 by dividing the number of passengers at the point by the maximum found in the filtered set. If no records exist or the maximum is zero, the intensity is set to 0. The result is ordered from highest to lowest intensity. |
| Subtítulo  | — | — |

---

---

## KPI: KM/Hora (Exceso de Velocidad)

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra los registros de exceso de velocidad de los conductores en el rango de fechas seleccionado, comparando la velocidad registrada contra el límite configurado por zona franca (`LIMITE_VEL_AUTOBUSES`). Si dicho parámetro no está configurado, el KPI no retorna resultados.

El resultado se presenta paginado con dos conjuntos de información:
1. **Total de registros** — para la paginación.
2. **Listado paginado** — conductores con velocidad registrada y límite aplicado, ordenados de mayor a menor velocidad.

> **Nota:** La lectora envía únicamente las telemetrías que ya superaron el límite de velocidad.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente cuando se recibe el **envío de telemetría** desde la lectora del bus con un exceso de velocidad detectado.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario puede definir turno, ramal, tipo de ruta y rango de fechas para acotar los resultados.

---

**Filtros disponibles**

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta los registros de exceso de velocidad en un rango de fechas dentro de una zona franca, comparando la velocidad registrada contra el límite configurado por parámetro de zona franca (LIMITE_VEL_AUTOBUSES). Si dicho parámetro no está configurado, el procedimiento no retorna ningún resultado y termina inmediatamente. Retorna dos conjuntos de resultados: el total de registros para paginación y el listado paginado de conductores con su velocidad registrada y el límite aplicado, ordenado de mayor a menor velocidad.

| Filtro       | Aplica  |
|--------------|---------|
| Turno        | **SÍ**  |
| Ramal        | **SÍ**  |
| Tipo de ruta | **SÍ**  |
| Fecha inicio | **SÍ**  |
| Fecha fin    | **SÍ**  |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                       |
|-------------------------------------|-------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                          |
| Evento disparador                   | Envío de telemetría                                         |
| Tópico en la cola                   | `exceeded-speed-limit`                                      |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_SPEED_EXCESS_AGGREGATION`                 |
| Parámetros procedimiento agrupación | `speed`, `summaryServiceId`                                 |

> El evento es disparado por el **envío de telemetría** desde la lectora del bus cuando se detecta una velocidad superior al límite configurado, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `exceeded-speed-limit` y ejecuta la agrupación. La lectora envía únicamente las telemetrías que ya superaron el límite de velocidad.
>
> El programa de agrupación realiza un **upsert** conservando siempre el **máximo valor de velocidad** para el conductor por día, dentro del mismo ramal.

---

**Operación y consulta**

| Campo                     | Valor                                                                                          |
|---------------------------|------------------------------------------------------------------------------------------------|
| Operación                 | Upsert en la tabla de exceso de velocidad, conservando el máximo valor por conductor por día y ramal |
| Tabla de hechos           | `SPEED_EXCESS`                                                                                 |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_SPEED_EXCESS`                                                            |

---

**Observación técnica**

El límite de velocidad para comparación ya existe como parámetro de zona franca (`LIMITE_VEL_AUTOBUSES`; ver pestaña de telemetría — límite velocidad autobuses). En la consulta, por conductor se trae el valor máximo de velocidad dentro del rango de fechas. Si el parámetro `LIMITE_VEL_AUTOBUSES` no está configurado para la zona franca, el procedimiento no retorna resultados y termina inmediatamente. La consulta es paginada.

La estructura de la tabla de hechos `SPEED_EXCESS` incluye: `IdExcesoVelocidad`, `zona franca`, `empresa transporte`, `turno`, `ramal`, `Fecha`, `IdConductor`, `NombreConductor` y `Velocidad`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta los registros de exceso de velocidad en un rango de fechas dentro de una zona franca, comparando la velocidad registrada contra el límite configurado por parámetro de zona franca (LIMITE_VEL_AUTOBUSES). Si dicho parámetro no está configurado, el procedimiento no retorna ningún resultado y termina inmediatamente. Retorna dos conjuntos de resultados: el total de registros para paginación y el listado paginado de conductores con su velocidad registrada y el límite aplicado, ordenado de mayor a menor velocidad. | Queries speed excess records within a date range in a free trade zone, comparing the recorded speed against the limit configured by the free trade zone parameter (LIMITE_VEL_AUTOBUSES). If this parameter is not configured, the procedure returns no results and terminates immediately. Returns two result sets: the total records for pagination and the paginated list of drivers with their recorded speed and applied limit, ordered from highest to lowest speed. |
| Subtítulo  | — | — |

---

---

## KPI: Mapa de Calor — Afluencia de Posible Uso

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra un mapa de calor de afluencia proyectada para el **día siguiente** a la fecha indicada, ubicando cada ruta en las coordenadas de su última parada (la de mayor orden en `STOPS_ROUTES`). La intensidad de cada punto se normaliza entre 0 y 1 según el total de pasajeros proyectados.

> **Restricción importante:** Este KPI acepta únicamente **un único día** como entrada. Si se envía un rango de fechas (fecha inicio distinta de fecha fin), el sistema retornará un resultado vacío.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real. El usuario debe seleccionar **un único día** como filtro (fecha inicio igual a fecha fin). El sistema proyectará la afluencia para el día siguiente a la fecha indicada.

---

**Filtros disponibles**

| Filtro       | Aplica                                  |
|--------------|-----------------------------------------|
| Turno        | **SÍ**                                  |
| Ramal        | **SÍ**                                  |
| Tipo de ruta | **SÍ**                                  |
| Fecha inicio | **SÍ**                                  |
| Fecha fin    | **SÍ** _(solo se permite filtrar un día)_ |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta el mapa de calor de afluencia proyectada para el día siguiente a la fecha indicada, ubicando cada ruta en las coordenadas de su última parada (la de mayor orden en STOPS_ROUTES). La intensidad de cada punto se normaliza entre 0 y 1 dividiendo el total de pasajeros proyectados del punto entre el máximo encontrado en el conjunto filtrado. Solo acepta un único día como entrada (@StartDate debe ser igual a @EndDate); si se envía un rango, retorna un resultset vacío. El resultado se ordena de mayor a menor intensidad.

| Filtro       | Aplica                                  |
|--------------|-----------------------------------------|
| Turno        | **SÍ**                                  |
| Ramal        | **SÍ**                                  |
| Tipo de ruta | **SÍ**                                  |
| Fecha inicio | **SÍ**                                  |
| Fecha fin    | **SÍ** _(solo se permite filtrar un día)_ |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                      |
|---------------------------|------------------------------------------------------------------------------------------------------------|
| Operación                 | Consulta de las paradas finales de cada ruta para devolver latitud, longitud y total de pasajeros predichos |
| Tabla de hechos           | —                                                                                                          |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_DEMAND_FORECAST_HEATMAP`                                                             |

---

**Observación técnica**

El procedimiento proyecta la afluencia del **día siguiente** a la fecha indicada. Cada ruta se ubica en las coordenadas de su última parada (la de mayor orden en `STOPS_ROUTES`). La intensidad se normaliza entre `0` y `1` dividiendo el total de pasajeros proyectados por punto entre el máximo del conjunto filtrado.

> **Restricción técnica:** El parámetro `@StartDate` debe ser igual a `@EndDate`. Si se envía un rango, el procedimiento retorna un result set vacío.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el mapa de calor de afluencia proyectada para el día siguiente a la fecha indicada, ubicando cada ruta en las coordenadas de su última parada (la de mayor orden en STOPS_ROUTES). La intensidad de cada punto se normaliza entre 0 y 1 dividiendo el total de pasajeros proyectados del punto entre el máximo encontrado en el conjunto filtrado. Solo acepta un único día como entrada (@StartDate debe ser igual a @EndDate); si se envía un rango, retorna un resultset vacío. El resultado se ordena de mayor a menor intensidad. | Queries the projected demand heat map for the day following the indicated date, placing each route at the coordinates of its last stop (the one with the highest order in STOPS_ROUTES). The intensity of each point is normalized between 0 and 1 by dividing the total projected passengers at the point by the maximum found in the filtered set. Only accepts a single day as input (@StartDate must equal @EndDate); if a range is provided, returns an empty result set. The result is ordered from highest to lowest intensity. |
| Subtítulo  | — | — |

---

---

## KPI: Sobrepoblación — Proyección vs. Disponibilidad

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la proyección de sobrepoblación por ramal para el **día siguiente** a la fecha indicada, comparando la ocupación proyectada de pasajeros contra la capacidad histórica disponible de buses. Los resultados priorizan los ramales con mayor riesgo de sobrepoblación (mayor diferencia entre proyectado y disponible).

Presenta dos conjuntos de información:
1. **Total de ramales** — para la paginación.
2. **Listado paginado** — ramales con ocupación proyectada, asientos disponibles y diferencia.

> **Restricción importante:** Este KPI acepta únicamente **un único día** como entrada. Si se envía un rango de fechas (fecha inicio distinta de fecha fin), el sistema retornará resultados vacíos.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real. El usuario debe seleccionar **un único día** como filtro (fecha inicio igual a fecha fin). El sistema calculará la proyección de sobrepoblación para el día siguiente.

---

**Filtros disponibles**

| Filtro       | Aplica                                  |
|--------------|-----------------------------------------|
| Turno        | **SÍ**                                  |
| Ramal        | **SÍ**                                  |
| Tipo de ruta | **SÍ**                                  |
| Fecha inicio | **SÍ**                                  |
| Fecha fin    | **SÍ** _(solo se permite filtrar un día)_ |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta la proyección de sobrepoblación por ramal para el día siguiente a la fecha indicada, comparando la ocupación proyectada de pasajeros contra la capacidad histórica disponible de buses. Solo acepta un único día como entrada (@StartDate debe ser igual a @EndDate); si se envía un rango, retorna resultados vacíos. El resultado se ordena por diferencia (proyectado menos disponible) de mayor a menor, priorizando los ramales con mayor riesgo de sobrepoblación. Retorna dos conjuntos de resultados: el total de ramales para paginación y el listado paginado con ocupación proyectada, asientos disponibles y diferencia por ramal.

| Filtro       | Aplica                                  |
|--------------|-----------------------------------------|
| Turno        | **SÍ**                                  |
| Ramal        | **SÍ**                                  |
| Tipo de ruta | **SÍ**                                  |
| Fecha inicio | **SÍ**                                  |
| Fecha fin    | **SÍ** _(solo se permite filtrar un día)_ |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                                                     |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| Operación                 | Consulta de predicciones por ramal para una fecha, comparando ocupación proyectada contra disponibilidad promediada histórica del servicio |
| Tabla de hechos           | —                                                                                                                                         |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_OVERPOPULATION_FORECAST`                                                                                            |

---

**Observación técnica**

Los datos de predicción y disponibilidad promedio se obtienen de la tabla de predicción. Los resultados se ordenan por diferencia (proyectado menos disponible) de mayor a menor, priorizando los ramales con mayor riesgo de sobrepoblación.

> **Restricción técnica:** El parámetro `@StartDate` debe ser igual a `@EndDate`. Si se envía un rango, el procedimiento retorna resultados vacíos.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta la proyección de sobrepoblación por ramal para el día siguiente a la fecha indicada, comparando la ocupación proyectada de pasajeros contra la capacidad histórica disponible de buses. Solo acepta un único día como entrada (@StartDate debe ser igual a @EndDate); si se envía un rango, retorna resultados vacíos. El resultado se ordena por diferencia (proyectado menos disponible) de mayor a menor, priorizando los ramales con mayor riesgo de sobrepoblación. Retorna dos conjuntos de resultados: el total de ramales para paginación y el listado paginado con ocupación proyectada, asientos disponibles y diferencia por ramal. | Queries the overpopulation projection by branch for the day following the indicated date, comparing the projected passenger occupancy against the historical available bus capacity. Only accepts a single day as input (@StartDate must equal @EndDate); if a range is provided, returns empty results. The result is ordered by difference (projected minus available) from highest to lowest, prioritizing branches with the highest overpopulation risk. Returns two result sets: the total number of branches for pagination and the paginated list with projected occupancy, available seats, and difference per branch. |
| Subtítulo  | — | — |

---
