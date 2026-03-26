# Documentación de KPIs — RideCode
## Pestaña: Mantenimiento

---

## Estructura de cada KPI

Cada KPI se documenta con dos secciones:

- **[Usuario]** — Información orientada al usuario final: qué muestra el KPI, cuándo se calcula la información, cómo se consulta, qué filtros aplican y notas visibles en el frontend.
- **[Técnico]** — Información orientada al equipo de desarrollo: fuente de datos, programa de agrupación, procedimientos, tabla de hechos, operaciones internas y textos de interfaz (tooltip y subtítulo en español e inglés).

> **Nota sobre la Descripción:** El campo *Descripción* de cada KPI es el texto que se muestra como **tooltip** en la página de KPIs y en el dashboard.

---

---

## KPI: Cumplimiento de requisitos (CTP, Marchamo, Póliza, DEKRA) — Barras

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el porcentaje de vehículos aprobados (con CTP, Marchamo, Póliza y DEKRA al día) por empresa de transporte, en comparación con el total de vehículos registrados.

- La empresa **cliente** no visualiza datos propios en esta consulta.
- La empresa de **transporte** solo visualiza los datos de su propia empresa.
- La **zona franca** visualiza los datos de todas las empresas de transporte de la zona.

> **Nota de fecha:** El subtítulo del KPI debe indicar que la fecha utilizada es la **Fecha fin**. El rango de fechas seleccionado se interpreta tomando la última fecha como el estado actual del vehículo.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se **crea o actualiza un autobús** en el sistema.
- Cuando se realiza una **aprobación** de un autobús.
- De forma **automática todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario solo necesita seleccionar la **Fecha fin** para definir el corte temporal; el sistema devolverá el estado de aprobación de los vehículos en esa fecha específica.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | NO     |
| Ramal        | NO     |
| Tipo de ruta | NO     |
| Fecha inicio | NO     |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta los autobuses aprobados en la fecha fin específica.

| Filtro       | Aplica |
|--------------|--------|
| Turno        | NO     |
| Ramal        | NO     |
| Tipo de ruta | NO     |
| Fecha inicio | NO     |
| Fecha fin    | **SÍ** |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor       |
|--------|-------------|
| Fuente | SQL Server  |

---

**Programa de agrupación**

| Campo                            | Valor                                              |
|----------------------------------|----------------------------------------------------|
| Programa de agrupación           | SÍ                                                 |
| Evento disparador                | Creación o actualización de un autobús · Aprobación · Ejecución diaria a las 00:00 (hora de la zona franca según su zona horaria) |
| Tópico en la cola                | `buses-updates`                                    |
| Procedimiento de agrupación      | `PRC_RIDECODE_KPI_AGGREGATION_SUMMARY_BUSES`       |
| Parámetros procedimiento agrupación | —                                               |

> El evento puede ser disparado por una acción del usuario (creación, actualización o aprobación de un autobús), lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `buses-updates` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que múltiples eventos sobre el mismo vehículo/servicio no generen registros duplicados, sino que actualicen un único registro agrupado en la tabla de hechos.

---

**Operación y consulta**

| Campo                    | Valor                                                    |
|--------------------------|----------------------------------------------------------|
| Operación                | Identificar en cada vehículo si fue aprobado o no (`buses.approved`) |
| Tabla de hechos          | `BUS_SUMMARY`                                            |
| Procedimiento de consulta| `PRC_RIDECODE_GET_KPI_COMPLIANCE_REQUIREMENTS_BUSES`     |

---

**Observación técnica**

Contar los vehículos de cada empresa de transporte que hayan sido marcados como aprobados versus el total de vehículos, para obtener el porcentaje de aprobación. El filtro se aplica contra la **Fecha fin** y no contra la Fecha inicio, ya que en un rango de fechas se toma la última fecha como el estado actual del vehículo.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta los autobuses aprobados en la fecha fin específica. | Queries the approved buses on the specific end date. |
| Subtítulo  | La fecha utilizada es la fecha fin. | The date used is the end date. |

---

---

## KPI: Matriz de mantenimiento por transportista

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el promedio de las calificaciones de mantenimiento de los autobuses por empresa de transporte. Para cada empresa, el sistema toma la última evaluación registrada de cada autobús dentro del rango de fechas seleccionado y calcula el promedio de esas calificaciones.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | NO     |
| Ramal        | NO     |
| Tipo de ruta | NO     |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta las evaluaciones en un rango de fechas, toma la última evaluación de cada autobús y las promedia para la misma empresa de transporte, se toma los valores de todo el rango de evaluaciones.

| Filtro       | Aplica |
|--------------|--------|
| Turno        | NO     |
| Ramal        | NO     |
| Tipo de ruta | NO     |
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

| Campo                     | Valor                                                                                                                                                                   |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Operación                 | A partir del `busId`, obtener la empresa de transporte; luego obtener la última evaluación de todos los autobuses de dicha empresa dentro del rango de fechas y calcular el promedio de las calificaciones obtenidas |
| Tabla de hechos           | —                                                                                                                                                                       |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_CARRIER_MAINTENANCE`                                                                                                                              |


**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta las evaluaciones en un rango de fechas, toma la última evaluación de cada autobús y las promedia para la misma empresa de transporte, se toma los valores de todo el rango de evaluaciones. | Queries evaluations within a date range, takes the last evaluation of each bus and averages them for the same transport company, considering all evaluations within the range. |
| Subtítulo  | — | — |

---
