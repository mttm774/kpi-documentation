# Documentación de KPIs — RideCode
## Pestaña: Servicio al Cliente

---

## Estructura de cada KPI

Cada KPI se documenta con dos secciones:

- **[Usuario]** — Información orientada al usuario final: qué muestra el KPI, cuándo se calcula la información, cómo se consulta, qué filtros aplican y notas visibles en el frontend.
- **[Técnico]** — Información orientada al equipo de desarrollo: fuente de datos, programa de agrupación, procedimientos, tabla de hechos, operaciones internas y textos de interfaz (tooltip y subtítulo en español e inglés).

> **Nota sobre la Descripción:** El campo *Descripción* de cada KPI es el texto que se muestra como **tooltip** en la página de KPIs y en el dashboard.

---

---

## KPI: Gestión de Tickets

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la cantidad de tickets gestionados, clasificados por estado: **abiertos**, **cerrados** y **sin respuesta**, en el rango de fechas seleccionado.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se **crea un ticket** en el sistema.
- Cuando se **cambia el estado de un ticket**.
- De forma **automática todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario puede filtrar por turno, ramal, tipo de ruta, fecha inicio y fecha fin para acotar los resultados.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta la cantidad de tickets gestionados según su estado (abiertos, cerrados y sin respuesta).

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                                                                          |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                                                                             |
| Evento disparador                   | Creación de ticket · Cambio de estado de ticket · Ejecución diaria a las 00:00 (hora de la zona franca según su zona horaria) |
| Tópico en la cola                   | `summarize-tickets`                                                                                            |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_AGGREGATION_SUMMARY_TICKETS`                                                                 |
| Parámetros procedimiento agrupación | —                                                                                                              |

> El evento puede ser disparado por la creación de un ticket o por un cambio en su estado, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `summarize-tickets` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que múltiples eventos sobre el mismo ticket no generen registros duplicados, sino que actualicen un único registro agrupado en la tabla de hechos.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                                                    |
|---------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| Operación                 | Contar el número de tickets por estado (abiertos, cerrados, sin respuesta) agrupados por zona franca, empresa de transporte, empresa cliente, ramal y turno, dentro del rango de fechas |
| Tabla de hechos           | `SUMMARY_TICKETS`                                                                                                                        |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_TICKETS_MANAGEMENT`                                                                                                |

---

**Observación técnica**

—

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta la cantidad de tickets gestionados según su estado (abiertos, cerrados y sin respuesta). | Queries the number of managed tickets by status (open, closed, and unanswered). |
| Subtítulo  | — | — |

---

---

## KPI: Tiempo Promedio de Respuesta

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el tiempo promedio, en horas, que transcurre entre la creación y el cierre de los tickets. Solo se consideran los tickets que ya han sido **cerrados** dentro del rango de fechas seleccionado.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin. El rango de fechas se aplica contra la **fecha de cierre** del ticket.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta el tiempo promedio de respuesta de tickets cerrados (en horas), calculado entre la fecha de creación y cierre del ticket, filtrado por fecha de cierre del ticket.

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

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

| Campo                     | Valor                                                                                                                         |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| Operación                 | Promedio del tiempo de cierre en horas de los tickets cerrados, aplicando los filtros definidos; el filtro de fecha se aplica contra la fecha de cierre del ticket |
| Tabla de hechos           | —                                                                                                                             |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_TICKETS_AVERAGE_TIME_RESPONSE`                                                                          |

---

**Observación técnica**

Solo se deben considerar los tickets con estado **cerrado**. El cálculo del tiempo promedio se realiza restando la fecha de creación a la fecha de cierre de cada ticket, expresando el resultado en horas.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el tiempo promedio de respuesta de tickets cerrados (en horas), calculado entre la fecha de creación y cierre del ticket, filtrado por fecha de cierre del ticket. | Queries the average response time of closed tickets (in hours), calculated between the ticket creation and closing dates, filtered by the ticket closing date. |
| Subtítulo  | — | — |

---

---

## KPI: Calificación General

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la calificación promedio de los servicios de autobuses evaluados por los pasajeros, incluyendo el promedio por empresa de transporte y el promedio general, filtrado por la fecha del servicio.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta la calificación promedio de los servicios de autobuses evaluados por los pasajeros, incluyendo el promedio por empresa y el promedio general, filtrado por fecha del servicio.

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

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
| Operación                 | Promedio del campo `Weighted` de la tabla `Evaluation_result`, agrupado por empresa de transporte |
| Tabla de hechos           | —                                                                                            |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_OVERALL_GRADE`                                                         |

---

**Observación técnica**

—

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta la calificación promedio de los servicios de autobuses evaluados por los pasajeros, incluyendo el promedio por empresa y el promedio general, filtrado por fecha del servicio. | Queries the average rating of bus services evaluated by passengers, including the average per company and the overall average, filtered by service date. |
| Subtítulo  | — | — |

---
