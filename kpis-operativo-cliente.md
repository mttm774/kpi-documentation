# Documentación de KPIs — RideCode
## Pestaña: Operativo Cliente

---

## Estructura de cada KPI

Cada KPI se documenta con dos secciones:

- **[Usuario]** — Información orientada al usuario final: qué muestra el KPI, cuándo se calcula la información, cómo se consulta, qué filtros aplican y notas visibles en el frontend.
- **[Técnico]** — Información orientada al equipo de desarrollo: fuente de datos, programa de agrupación, procedimientos, tabla de hechos, operaciones internas y textos de interfaz (tooltip y subtítulo en español e inglés).

> **Nota sobre la Descripción:** El campo *Descripción* de cada KPI es el texto que se muestra como **tooltip** en la página de KPIs y en el dashboard.

---

---

## KPI: Autobuses capacidad cumplida

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el total de registros de capacidad cumplida de buses en el rango de fechas seleccionado, filtrando únicamente los registros no atendidos dentro de la zona franca.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se recibe el **envío de telemetría desde la lectora** del bus.
- De forma **automática todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario puede seleccionar ramal, tipo de ruta, fecha inicio y fecha fin para acotar los resultados.

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

Consulta los registros de capacidad cumplida de buses en un rango de fechas dentro de una zona franca, filtrando únicamente los registros no atendidos. Retorna el total de registros encontrados.

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

| Campo  | Valor   |
|--------|---------|
| Fuente | MongoDB |

---

**Programa de agrupación**

| Campo                               | Valor                                                |
|-------------------------------------|------------------------------------------------------|
| Programa de agrupación              | SÍ                                                   |
| Evento disparador                   | Envío de telemetría desde la lectora                 |
| Tópico en la cola                   | `bus-capacity-fullfilled`                            |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_FULFILLED_CAPACITY_AGGREGATION`    |
| Parámetros procedimiento agrupación | `SummaryServiceId`, `FulfilledDate`, `Attended`      |

> El evento es disparado por el **envío de telemetría desde la lectora**, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `bus-capacity-fullfilled` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que múltiples eventos sobre el mismo registro de telemetría no generen duplicados, sino que inserten un único registro en la tabla de hechos.

---

**Operación y consulta**

| Campo                     | Valor                                            |
|---------------------------|--------------------------------------------------|
| Operación                 | Inserción de registros de capacidad cumplida     |
| Tabla de hechos           | `FULFILLED_CAPACITY`                             |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_FULFILLED_CAPACITY`        |

---

**Observación técnica**

Se consultan los registros de la tabla de hechos `FULFILLED_CAPACITY` dentro del rango de fechas indicado, filtrando únicamente los registros no atendidos (`Attended = 0`). El resultado es el conteo total de dichos registros por zona franca.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta los registros de capacidad cumplida de buses en un rango de fechas dentro de una zona franca, filtrando únicamente los registros no atendidos. Retorna el total de registros encontrados. | Queries the bus fulfilled capacity records within a date range in a free trade zone, filtering only unattended records. Returns the total number of records found. |
| Subtítulo  | — | — |

---

---

## KPI: Solicitudes de cambio de ruta

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la sumatoria total de solicitudes de cambio de ruta en el rango de fechas seleccionado, filtrando únicamente los registros no atendidos.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se realiza el **registro o actualización de un cambio de ruta** en el sistema.
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

Consulta las solicitudes de cambio de ruta en un rango de fechas dentro de una zona franca, filtrando únicamente los registros no atendidos. Retorna la sumatoria total de solicitudes de cambio.

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

| Campo                               | Valor                                               |
|-------------------------------------|-----------------------------------------------------|
| Programa de agrupación              | SÍ                                                  |
| Evento disparador                   | Registro o actualización de cambio de ruta          |
| Tópico en la cola                   | `route-change-request`                              |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_ROUTE_CHANGE_AGGREGATION`         |
| Parámetros procedimiento agrupación | `SummaryServiceId`, `Attended`                      |

> El evento puede ser disparado por el **registro o actualización de un cambio de ruta**, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `route-change-request` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que múltiples eventos sobre la misma solicitud de cambio no generen registros duplicados, sino que actualicen un único registro agrupado en la tabla de hechos mediante operación MERGE.

---

**Operación y consulta**

| Campo                     | Valor                                                |
|---------------------------|------------------------------------------------------|
| Operación                 | MERGE de solicitudes de cambio de ruta agrupadas     |
| Tabla de hechos           | `ROUTE_CHANGE_SUMMARY`                               |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_ROUTE_CHANGE`                  |

---

**Observación técnica**

Se consultan los registros agrupados de la tabla `ROUTE_CHANGE_SUMMARY`, filtrando únicamente los no atendidos (`Attended = 0`) dentro del rango de fechas. La estructura agrupada incluye: `ID_RESUMEN`, `TURNO`, `RAMAL`, `TIPO_RUTA`, `FECHA` y `CANTIDAD`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta las solicitudes de cambio de ruta en un rango de fechas dentro de una zona franca, filtrando únicamente los registros no atendidos. Retorna la sumatoria total de solicitudes de cambio. | Queries route change requests within a date range in a free trade zone, filtering only unattended records. Returns the total sum of change requests. |
| Subtítulo  | — | — |

---

---

## KPI: Ingresos por ruta

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra los ingresos totales agrupados por tipo de ruta (Parque, Privada, Especial) para los servicios prestados en el rango de fechas seleccionado. Solo se consideran los servicios que han tenido la primera revisión por parte del transportista.

- Para rutas de tipo **Parque**, el ingreso se calcula sobre la tarifa de transporte.
- Para los demás tipos de ruta, se utiliza la tarifa de servicio general.

---

**¿Cuándo se calcula la información?**

La información de este KPI utiliza un programa de agrupación. Sin embargo, los detalles técnicos del evento disparador, la cola y el procedimiento de agrupación están pendientes de definición.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta y suma los ingresos por tipo de ruta dentro del rango de fechas, turno y ramal definidos por el usuario.

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

Consulta los ingresos totales agrupados por tipo de ruta (Parque, Privada, Especial) en un rango de fechas dentro de una zona franca, considerando únicamente los servicios aprobados por cumplimiento de empresa de transporte. Para rutas de tipo Parque, el ingreso se calcula sobre la tarifa de transporte; para los demás tipos, se usa la tarifa de servicio general. La fecha se ajusta según la zona horaria configurada para la zona franca.

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
| Programa de agrupación              | SÍ    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Los detalles del programa de agrupación (evento disparador, cola y procedimiento) están pendientes de definición.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                     |
|---------------------------|-----------------------------------------------------------------------------------------------------------|
| Operación                 | Suma de ingresos por tipo de ruta para los servicios en el rango de fechas, turno y ramal seleccionados   |
| Tabla de hechos           | —                                                                                                         |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_ROUTES_INCOME`                                                                      |

---

**Observación técnica**

Solo se consideran los servicios que han tenido la primera revisión por parte del transportista. Para rutas de tipo **Parque**, el ingreso se calcula sobre la tarifa de transporte; para los demás tipos, se utiliza la tarifa de servicio general. La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta los ingresos totales agrupados por tipo de ruta (Parque, Privada, Especial) en un rango de fechas dentro de una zona franca, considerando únicamente los servicios aprobados por cumplimiento de empresa de transporte. Para rutas de tipo Parque, el ingreso se calcula sobre la tarifa de transporte; para los demás tipos, se usa la tarifa de servicio general. La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries total income grouped by route type (Park, Private, Special) within a date range in a free trade zone, considering only services approved by transport company compliance. For Park-type routes, income is calculated on the transport fare; for other types, the general service fare is used. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Rutas más utilizadas

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el Top 10 de rutas más utilizadas en el rango de fechas seleccionado, ordenadas de mayor a menor por cantidad de pasajeros transportados. Solo se consideran servicios aprobados por cumplimiento de empresa de transporte y se excluyen rutas sin pasajeros.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros definidos por el usuario: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

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

Consulta el Top 10 de rutas más utilizadas en un rango de fechas dentro de una zona franca, ordenadas de mayor a menor por cantidad de pasajeros transportados. Solo considera servicios aprobados por cumplimiento de empresa de transporte y excluye rutas sin pasajeros. La fecha se ajusta según la zona horaria configurada para la zona franca.

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

| Campo                     | Valor                                                                                          |
|---------------------------|------------------------------------------------------------------------------------------------|
| Operación                 | Conteo por ramal de los servicios atendidos para el turno, ramal, tipo de ruta y rango de fechas |
| Tabla de hechos           | —                                                                                              |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_TOP_ROUTES`                                                              |

---

**Observación técnica**

Solo se consideran los servicios aprobados por cumplimiento de empresa de transporte (`ComplianceTransportCompanyApproved = 1`). La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Nota de interfaz:** El texto _"Solo se considera los servicios aprobados por transportista"_ debe mostrarse al pie de la página en color tenue y en texto de menor tamaño. Esta indicación aplica para todas las páginas.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el Top 10 de rutas más utilizadas en un rango de fechas dentro de una zona franca, ordenadas de mayor a menor por cantidad de pasajeros transportados. Solo considera servicios aprobados por cumplimiento de empresa de transporte y excluye rutas sin pasajeros. La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries the Top 10 most-used routes within a date range in a free trade zone, ordered from highest to lowest by number of passengers transported. Only considers services approved by transport company compliance and excludes routes with no passengers. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Ocupación por turno

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la ocupación de buses agrupada por turno mediante un gráfico de barras apiladas. Presenta dos métricas:

- **Capacidad disponible por turno** — cantidad de asientos disponibles sin ocupar.
- **Ocupación real por turno** — cantidad de pasajeros que efectivamente abordaron.

La capacidad disponible nunca es negativa: si los pasajeros superan la capacidad del bus, el valor se limita a cero.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros definidos por el usuario: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

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

Consulta la ocupación de buses agrupada por turno en un rango de fechas dentro de una zona franca, considerando únicamente los servicios aprobados por cumplimiento de empresa de transporte. Retorna dos conjuntos de resultados destinados a un gráfico de barras apiladas: el primero con la capacidad disponible por turno y el segundo con la ocupación real por turno. La capacidad disponible nunca es negativa (se limita a 0 si los pasajeros superan la capacidad). La fecha se ajusta según la zona horaria configurada para la zona franca.

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

| Campo                     | Valor                                                                                                   |
|---------------------------|---------------------------------------------------------------------------------------------------------|
| Operación                 | Suma de ocupación y suma de capacidad del bus asociado al servicio, ambas agrupadas por turno           |
| Tabla de hechos           | —                                                                                                       |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_OCCUPANCY_BY_SHIFT`                                                               |

---

**Observación técnica**

Se consulta la ocupación (suma de pasajeros) y la capacidad (suma de la capacidad del bus asociado al servicio) desde `SUMMARY_SERVICE`, agrupadas por turno. La capacidad disponible se calcula como `capacidad - ocupación`, limitada a un mínimo de `0`. Solo se consideran los servicios aprobados por cumplimiento de empresa de transporte. La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Nota de interfaz:** El texto _"Solo se considera los servicios aprobados por transportista"_ debe mostrarse al pie de la página en color tenue y en texto de menor tamaño. Esta indicación aplica para todas las páginas.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta la ocupación de buses agrupada por turno en un rango de fechas dentro de una zona franca, considerando únicamente los servicios aprobados por cumplimiento de empresa de transporte. Retorna dos conjuntos de resultados destinados a un gráfico de barras apiladas: el primero con la capacidad disponible por turno y el segundo con la ocupación real por turno. La capacidad disponible nunca es negativa (se limita a 0 si los pasajeros superan la capacidad). La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries bus occupancy grouped by shift within a date range in a free trade zone, considering only services approved by transport company compliance. Returns two result sets for a stacked bar chart: the first with available capacity per shift and the second with actual occupancy per shift. Available capacity is never negative (capped at 0 if passengers exceed capacity). The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Llegadas a terminal

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el análisis de puntualidad de los servicios de buses, comparando la hora de llegada real contra la hora de llegada programada. Clasifica cada servicio como **a tiempo** o **retrasado** según el umbral de minutos configurado por zona franca (`TIEMPO_SERVICIO_RETRASADO`, por defecto 10 minutos).

Presenta tres conjuntos de información:
1. **Detalle de los servicios retrasados.**
2. **Porcentaje de cumplimiento por ruta.**
3. **Distribución global de puntualidad.**

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros definidos por el usuario: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

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

Consulta los servicios de buses en un rango de fechas dentro de una zona franca y evalúa su puntualidad comparando la hora de llegada real contra la hora de llegada programada. Un servicio se considera retrasado si supera el umbral de minutos configurado por parámetro de zona franca (TIEMPO_SERVICIO_RETRASADO, por defecto 10 minutos). Retorna tres conjuntos de resultados: el detalle de los servicios retrasados, el porcentaje de cumplimiento por ruta y la distribución global de puntualidad. La fecha se ajusta según la zona horaria configurada para la zona franca.

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

| Campo                     | Valor                                                                                            |
|---------------------------|--------------------------------------------------------------------------------------------------|
| Operación                 | Cálculo de llegadas tardías o a tiempo en comparación con los parámetros de entrada configurados |
| Tabla de hechos           | —                                                                                                |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_TERMINAL_ARRIVALS`                                                         |

---

**Observación técnica**

Los datos provienen de la tabla `SUMMARY_SERVICE`. La puntualidad se evalúa comparando `ArrivalTimeAtDestination` (hora de llegada real) con la hora de llegada programada del servicio. Un servicio se considera retrasado si supera el parámetro `TIEMPO_SERVICIO_RETRASADO` configurado en la zona franca (por defecto: 10 minutos). La fecha se ajusta según la zona horaria configurada para la zona franca.

> **Tarea pendiente de desarrollo:** Se debe agregar el campo `ArrivalTimeAtDestination` (`hora_llegada_destino`) a la tabla `SUMMARY_SERVICE`. La lectora debe enviarlo al momento de llegar al destino.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta los servicios de buses en un rango de fechas dentro de una zona franca y evalúa su puntualidad comparando la hora de llegada real contra la hora de llegada programada. Un servicio se considera retrasado si supera el umbral de minutos configurado por parámetro de zona franca (TIEMPO_SERVICIO_RETRASADO, por defecto 10 minutos). Retorna tres conjuntos de resultados: el detalle de los servicios retrasados, el porcentaje de cumplimiento por ruta y la distribución global de puntualidad. La fecha se ajusta según la zona horaria configurada para la zona franca. | Queries bus services within a date range in a free trade zone and evaluates punctuality by comparing the actual arrival time against the scheduled arrival time. A service is considered delayed if it exceeds the minute threshold configured by the free trade zone parameter (TIEMPO_SERVICIO_RETRASADO, default 10 minutes). Returns three result sets: the detail of delayed services, the compliance percentage per route, and the global punctuality distribution. The date is adjusted according to the time zone configured for the free trade zone. |
| Subtítulo  | — | — |

---

---

## KPI: Rutas de preferencia

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra un mapa de calor de rutas preferidas construido a partir de los abordajes por coordenada geográfica en el rango de fechas seleccionado. La intensidad de cada punto en el mapa se normaliza entre 0.1 y 0.9 según el mínimo y máximo de abordajes por coordenada. Solo se dibujan los trayectos del ramal seleccionado en los filtros.

Presenta tres conjuntos de información:
1. **Puntos del mapa de calor** con su intensidad normalizada y total de abordajes.
2. **Resumen global** de puntos únicos y abordajes totales.
3. **Trazado ordenado** de las rutas con presencia en el mapa de calor.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se realiza la **aprobación de un servicio por parte del transportista**.
- De forma **automática todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario puede definir turno, ramal, tipo de ruta y rango de fechas para acotar los resultados. Solo se dibujan los trayectos del ramal seleccionado.

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

Consulta los datos de abordajes por coordenada geográfica en un rango de fechas dentro de una zona franca, para construir un mapa de calor de rutas preferidas. La intensidad de cada punto se normaliza entre 0.1 y 0.9 en función del mínimo y máximo de abordajes agrupados por coordenada. Retorna tres conjuntos de resultados: los puntos del mapa de calor con su intensidad normalizada y total de abordajes, el resumen global de puntos únicos y abordajes totales, y el trazado ordenado de las rutas que tienen presencia en el mapa de calor.

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

| Campo                               | Valor                                                  |
|-------------------------------------|--------------------------------------------------------|
| Programa de agrupación              | SÍ                                                     |
| Evento disparador                   | Aprobación de un servicio por parte del transportista  |
| Tópico en la cola                   | `transport-compliance-approval`                        |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_PREFERENCE_ROUTES_AGGREGATION`       |
| Parámetros procedimiento agrupación | `summaryServiceId`                                     |

> El evento es disparado por la **aprobación de un servicio por parte del transportista**, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `transport-compliance-approval` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación realiza un MERGE por ruta, tipo de ruta y turno de la cantidad de pasajeros que abordaron, garantizando que no se generen registros duplicados y que se actualice un único registro agrupado en la tabla de hechos.

---

**Operación y consulta**

| Campo                     | Valor                                                                       |
|---------------------------|-----------------------------------------------------------------------------|
| Operación                 | MERGE por ruta, tipo de ruta y turno de la cantidad de pasajeros abordados  |
| Tabla de hechos           | `RUTAS_PREFERENCIA`                                                         |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_PREFERENCE_ROUTES_HEATMAP`                            |

---

**Observación técnica**

Solo se deben dibujar los trayectos del ramal seleccionado en los filtros. La intensidad de cada punto del mapa de calor se normaliza entre `0.1` y `0.9` en función del mínimo y máximo de abordajes agrupados por coordenada (`latitud`, `longitud`).

La estructura de la tabla de hechos `RUTAS_PREFERENCIA` incluye: `idRutaPreferencia`, `ZonaFranca`, `Empresa cliente`, `Empresa transporte`, `fecha`, `turno`, `Ramal`, `Tipo de ruta`, `cantidadAbordajes`, `latitud` y `longitud`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta los datos de abordajes por coordenada geográfica en un rango de fechas dentro de una zona franca, para construir un mapa de calor de rutas preferidas. La intensidad de cada punto se normaliza entre 0.1 y 0.9 en función del mínimo y máximo de abordajes agrupados por coordenada. Retorna tres conjuntos de resultados: los puntos del mapa de calor con su intensidad normalizada y total de abordajes, el resumen global de puntos únicos y abordajes totales, y el trazado ordenado de las rutas que tienen presencia en el mapa de calor. | Queries boarding data by geographic coordinate within a date range in a free trade zone, to build a heat map of preferred routes. The intensity of each point is normalized between 0.1 and 0.9 based on the minimum and maximum boardings grouped by coordinate. Returns three result sets: the heat map points with their normalized intensity and total boardings, the global summary of unique points and total boardings, and the ordered route trace of routes present in the heat map. |
| Subtítulo  | — | — |

---
