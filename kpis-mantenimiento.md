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

---

## KPI: Calificación de unidad (usuario) por placa — Barras

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el promedio de las calificaciones que los pasajeros asignaron a cada autobús, basándose en evaluaciones realizadas durante servicios aprobados por el transportista. Los resultados se presentan agrupados por placa de autobús.

- La **zona franca** puede visualizar las calificaciones de todos los autobuses de la zona.
- La empresa de **transporte** solo visualiza las calificaciones de sus propios autobuses.
- La empresa **cliente** no visualiza ningún dato en este KPI.

> **Nota importante:** Las fechas de filtro se aplican contra la **fecha del servicio**, no contra la fecha en que se realizó la evaluación.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio, fecha fin y placa.

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

Consulta las evaluaciones de autobuses realizadas por los pasajeros de servicios aprobados por el transportista y las fechas se filtran considerando la fecha del servicio y no la fecha de la evaluación.

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |
| Placa        | **SÍ** |

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

| Campo                     | Valor                                                                                                                                                          |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Operación                 | Promedio del campo `Weighted` de la tabla `evaluationResult`, agrupado por autobús, filtrando por tipo de evaluación **autobús** y aplicando turno, ramal, tipo de ruta y rango de fechas desde `summaryService.startDate` |
| Tabla de hechos           | —                                                                                                                                                              |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_UNIT_RATING`                                                                                                                             |

---

**Observación técnica**

El rango de fechas filtra contra el campo `startDate` de `summaryService`, no contra la fecha de la evaluación. Solo se deben incluir evaluaciones del tipo **autobús**.

Comportamiento según tipo de empresa:
- **Zona franca:** visualiza las calificaciones de todos los autobuses de la zona.
- **Empresa de transporte:** visualiza únicamente las calificaciones de sus propios autobuses.
- **Empresa cliente:** no se retornan datos.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta las evaluaciones de autobuses realizadas por los pasajeros de servicios aprobados por el transportista y las fechas se filtran considerando la fecha del servicio y no la fecha de la evaluación. | Queries bus evaluations made by passengers of carrier-approved services; dates are filtered based on the service date, not the evaluation date. |
| Subtítulo  | — | — |

---

---

## KPI: Vida útil buses (promedio Año/Modelo) — Barras

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el promedio del año/modelo de los autobuses por empresa de transporte, reflejando la antigüedad promedio de la flota en la fecha de corte seleccionada.

- La empresa **cliente** no visualiza datos en este KPI.
- La empresa de **transporte** solo visualiza los datos de su propia flota.
- La **zona franca** visualiza los datos de todas las empresas de transporte de la zona.

> **Nota de fecha:** El subtítulo del KPI debe indicar: _"La fecha utilizada es la fecha fin"_. El estado de los vehículos se evalúa tomando la fecha fin como punto de corte.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se **crea o actualiza un autobús** en el sistema.
- De forma **automática todos los días a las 23:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario.

Esto significa que los datos siempre reflejan el estado más reciente disponible, sin necesidad de que el usuario realice ninguna acción adicional.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario solo necesita seleccionar la **Fecha fin** para definir el corte temporal; el sistema devolverá el promedio del año/modelo de los autobuses de cada empresa de transporte en esa fecha.

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

Consulta los modelos de los autobuses por transportista y los promedia.

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

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                                                              |
|-------------------------------------|----------------------------------------------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                                                                 |
| Evento disparador                   | Creación o actualización de un autobús · Ejecución diaria a las 23:00 (hora de la zona franca según su zona horaria) |
| Tópico en la cola                   | `buses_updates`                                                                                    |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_AGGREGATION_SUMMARY_BUSES`                                                       |
| Parámetros procedimiento agrupación | —                                                                                                  |

> El evento puede ser disparado por una acción del usuario (creación o actualización de un autobús), lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `buses_updates` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 23:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que múltiples eventos sobre el mismo vehículo no generen registros duplicados, sino que actualicen un único registro agrupado en la tabla de hechos.

---

**Operación y consulta**

| Campo                     | Valor                                                                          |
|---------------------------|--------------------------------------------------------------------------------|
| Operación                 | Almacenar en la tabla de agregación el año/modelo del vehículo (`buses.model`) |
| Tabla de hechos           | `BUS_SUMMARY`                                                                  |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_USE_LIFE_BUSES`                                          |

---

**Observación técnica**

Se calcula el promedio de los modelos de los vehículos de las empresas de transporte a la **Fecha fin** de consulta.

Comportamiento según tipo de empresa:
- **Empresa cliente:** no se retornan datos.
- **Empresa de transporte:** visualiza únicamente los datos de su propia empresa.
- **Zona franca:** visualiza los datos de todas las empresas de transporte de la zona.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta los modelos de los autobuses por transportista y los promedia. | Queries the bus models by carrier and averages them. |
| Subtítulo  | La fecha utilizada es la fecha fin. | The date used is the end date. |

---

---

## KPI: Defectos en unidades (varadas) — Barras

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la cantidad de unidades que registraron alertas de autobús varado, reportadas por conductores o pasajeros. Independientemente de cuántas veces se reporte el mismo servicio, cada unidad se cuenta **una única vez** por servicio.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se recibe **telemetría del autobús** que genera una alerta de unidad varada.
- Cuando un **pasajero registra una alerta** desde la aplicación.
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

Se consulta las alertas que se hayan reportado por los conductores o pasajeros para unidades varadas. No importa cuántas veces se reporte el mismo servicio por pasajero o conductor, se cuenta una única vez.

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

| Campo  | Valor                |
|--------|----------------------|
| Fuente | Cola / SQL Server    |

---

**Programa de agrupación**

| Campo                               | Valor                                                                                              |
|-------------------------------------|----------------------------------------------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                                                                 |
| Evento disparador                   | Recepción de telemetría · Registro de alerta de pasajero                                           |
| Tópico en la cola                   | `bus-alert`                                                                                        |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_AGGREGATION_BUSES_ALERT`                                                         |
| Parámetros procedimiento agrupación | `Freezone`, `summaryservice`, `busid`, `alertdate`, `alerttype`                                    |

> El evento puede ser disparado por la recepción de telemetría del autobús o por el registro de una alerta por parte de un pasajero, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `bus-alert` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que múltiples alertas sobre el mismo servicio no generen registros duplicados, sino que actualicen un único registro agrupado en la tabla de hechos.

---

**Operación y consulta**

| Campo                     | Valor                                                               |
|---------------------------|---------------------------------------------------------------------|
| Operación                 | Almacenar en la tabla de agregación si la unidad tuvo registro de alerta de unidad varada |
| Tabla de hechos           | `BUSES_ALERT`                                                       |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_STRANDED_ALERT`                               |

---

**Observación técnica**

El payload del mensaje en la cola tiene la siguiente estructura:

| Campo              | Tipo       | Descripción |
|--------------------|------------|-------------|
| `summaryServiceId` | `string`   | Puede ser nulo cuando la lectora no está asociada a un servicio activo. |
| `alertDate`        | `datetime` | Corresponde a la fecha/hora del `summaryService.startDate`. |
| `freeZoneId`       | `string`   | Zona franca del servicio (telemetría) o del pasajero (alerta reportada). |
| `busId`            | `string`   | Si proviene de la lectora, llega diligenciado. Si proviene de una alerta de pasajero, debe calcularse a partir del `summaryServiceId` (que en ese caso puede ser `NULL`). |
| `spanishAlertText` | `string`   | Texto descriptivo de la alerta en español. |

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Se consulta las alertas que se hayan reportado por los conductores o pasajeros para unidades varadas. No importa cuántas veces se reporte el mismo servicio por pasajero o conductor, se cuenta una única vez. | Queries alerts reported by drivers or passengers for stranded units. Regardless of how many times the same service is reported, it is counted only once. |
| Subtítulo  | — | — |

---

---

## KPI: Accidentalidad — Barras

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la cantidad de unidades que registraron alertas de accidentalidad, reportadas por conductores o pasajeros. Independientemente de cuántas veces se reporte el mismo servicio, cada unidad se cuenta **una única vez** por servicio.

- La empresa **cliente** no visualiza datos en este KPI.
- La empresa de **transporte** solo visualiza los datos de su propia flota.
- La **zona franca** visualiza los datos de todas las empresas de transporte de la zona.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se recibe **telemetría del autobús** que genera una alerta de accidentalidad.
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

Se consulta las alertas de accidentalidad que se hayan reportado por los conductores o pasajeros. No importa cuántas veces se reporte el mismo servicio por pasajero o conductor, se cuenta una única vez.

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

| Campo  | Valor             |
|--------|-------------------|
| Fuente | Cola / SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                                          |
|-------------------------------------|--------------------------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                                             |
| Evento disparador                   | Recepción de telemetría · Ejecución diaria a las 00:00 (hora de la zona franca según su zona horaria) |
| Tópico en la cola                   | `bus-alert`                                                                    |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_AGGREGATION_BUSES_ALERT`                                     |
| Parámetros procedimiento agrupación | `Freezone`, `summaryservice`, `busid`, `alertdate`, `alerttype`                |

> El evento es disparado por la recepción de telemetría del autobús, lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `bus-alert` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que múltiples alertas sobre el mismo servicio no generen registros duplicados, sino que actualicen un único registro agrupado en la tabla de hechos.

---

**Operación y consulta**

| Campo                     | Valor                                                                              |
|---------------------------|------------------------------------------------------------------------------------|
| Operación                 | Almacenar en la tabla de agregación si la unidad tuvo registro de accidentalidad   |
| Tabla de hechos           | `BUSES_ALERT`                                                                      |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_ACCIDENTALITY`                                               |

---

**Observación técnica**

Se contabilizan los vehículos de las empresas de transporte que hayan tenido registro de unidad accidentada en el rango de fechas consultado. Sin importar cuántas alertas se generen para el mismo servicio, se cuenta una única vez por unidad.

Comportamiento según tipo de empresa:
- **Empresa cliente:** no se retornan datos.
- **Empresa de transporte:** visualiza únicamente los datos de su propia empresa.
- **Zona franca:** visualiza los datos de todas las empresas de transporte de la zona.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Se consulta las alertas de accidentalidad que se hayan reportado por los conductores o pasajeros. No importa cuántas veces se reporte el mismo servicio por pasajero o conductor, se cuenta una única vez. | Queries accident alerts reported by drivers or passengers. Regardless of how many times the same service is reported, it is counted only once. |
| Subtítulo  | — | — |

---

---

## KPI: Documentación de mantenimiento (registro semanal) — Barras

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la proporción de autobuses que tienen registros de mantenimiento dentro del rango de fechas seleccionado, comparado contra el total de vehículos activos por empresa de transporte.

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

Se consulta los registros de mantenimiento realizados para los autobuses en el rango de fechas.

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

| Campo                     | Valor                                                                                                                                                                         |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Operación                 | Consultar en `BUS_MAINTENANCE` los autobuses con registros de mantenimiento en el rango de fechas, agruparlos por empresa de transporte y calcular la proporción versus el total de vehículos activos de cada empresa |
| Tabla de hechos           | —                                                                                                                                                                             |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_MAINTENANCE_DOCUMENTATION`                                                                                                                              |

---

**Observación técnica**

— _(sin observación adicional proporcionada)_

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Se consulta los registros de mantenimiento realizados para los autobuses en el rango de fechas. | Queries the maintenance records performed for buses within the selected date range. |
| Subtítulo  | — | — |

---
